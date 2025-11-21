"""

Generate a JSON dump of IAM permissions for a given role.
Anything that looks like an account ID (12 digit number) will cause the script to fail,
to prevent committing sensitive information to a repo.

Sensitive account IDs can be found/replaced with aliases using the command line arguments.
The replaced values will be in the format ${alias}.

Usage:
  python export_role_policies.py <role_name> [<find>=<replace> ...]

"""

import json
import re
import sys

from argparse import ArgumentParser
from collections import defaultdict

import boto3


def list_role_policies(client, role_name):
    inline_policies = []
    paginator = client.get_paginator('list_role_policies')
    for page in paginator.paginate(RoleName=role_name):
        inline_policies.extend(page['PolicyNames'])
    return inline_policies


def get_role_policy(client, role_name, policy_name):
    response = client.get_role_policy(RoleName=role_name, PolicyName=policy_name)
    return response['PolicyDocument']['Statement']


def list_attached_role_policies(client, role_name):
    attached_policies = []
    paginator = client.get_paginator('list_attached_role_policies')
    for page in paginator.paginate(RoleName=role_name):
        attached_policies.extend(page['AttachedPolicies'])
    return attached_policies


def get_attached_role_policy(client, policy_arn):
    response = client.get_policy(PolicyArn=policy_arn)
    default_version_id = response['Policy']['DefaultVersionId']
    version_response = client.get_policy_version(
        PolicyArn=policy_arn,
        VersionId=default_version_id
    )
    return version_response['PolicyVersion']['Document']['Statement']


def main(role, aliases):
    client = boto3.client('iam')
    policy_map = defaultdict(lambda: defaultdict(dict))

    # Get inline policies for the role
    for policy_name in list_role_policies(client, role):
        permissions = get_role_policy(client, role, policy_name)
        policy_map['inline'][policy_name] = permissions

    # Get attached policies for the role
    for attached_policy in list_attached_role_policies(client, role):
        policy_name = attached_policy['PolicyName']
        policy_arn = attached_policy['PolicyArn']
        permissions = get_attached_role_policy(client, policy_arn)
        policy_map['attached'][policy_name] = permissions

    json_text = json.dumps(policy_map, indent=2)
    for search, replace in aliases.items():
        json_text = re.sub(search, f"${{{replace}}}", json_text)

    # Fail on anything that looks like an account ID
    # e.g. :123456789012:
    matches = set(re.findall(r"\D(\d{12})\D", json_text))
    if matches:
        print("Warning! Found potential account IDs in policies.\n"
              "These should be replaced with an alias before committing to a repo:\n"
              f"{', '.join(matches)}",
              file=sys.stderr)
        sys.exit(1)

    print(json_text)


if __name__ == "__main__":
    parser = ArgumentParser(description="Export IAM policies for a given role and account")
    parser.add_argument("role", help="Role to export")
    parser.add_argument("aliases", nargs='*',
                        help="A list of aliases to apply. E.g. 123456789012=prod_account")
    args = parser.parse_args()
    alias_map = {alias.split('=')[0]: alias.split('=')[1] for alias in args.aliases}
    main(args.role, alias_map)
