"""

Generate a JSON dump of IAM permissions for a given role.
Anything that looks like an account ID (12 digit number) will cause the script to fail,
to prevent committing sensitive information to a repo.

Sensitive account IDs can be found/replaced with aliases using the command line arguments.
The replaced values will be in the format ${alias}.

Prerequisite:
  You must be logged in to an active SSO session.

Usage:
  scripts/python export_role_policies.py <environment> <role_name> [<find>=<replace> ...]

"""

import json
import re
import sys

from argparse import ArgumentParser
from collections import defaultdict

import boto3


def list_role_policies(client, role_name: str) -> list:
    inline_policies = []
    try:
        paginator = client.get_paginator('list_role_policies')
        for page in paginator.paginate(RoleName=role_name):
            inline_policies.extend(page['PolicyNames'])
    except client.exceptions.UnauthorizedSSOTokenError as err:
        print(f"A valid SSO session is required.\n{err}\n", file=sys.stderr)
        sys.exit(2)
    except client.exceptions.NoSuchEntityException as err:
        print(f"{err}\nAre you using the correct AWS Profile?", file=sys.stderr)
        sys.exit(2)
    return inline_policies


def get_role_policy(client, role_name, policy_name) -> str:
    response = client.get_role_policy(RoleName=role_name, PolicyName=policy_name)
    return response['PolicyDocument']['Statement']


def list_attached_role_policies(client, role_name: str) -> list:
    attached_policies = []
    paginator = client.get_paginator('list_attached_role_policies')
    for page in paginator.paginate(RoleName=role_name):
        attached_policies.extend(page['AttachedPolicies'])
    return attached_policies


def get_attached_role_policy(client, policy_arn: str) -> str:
    response = client.get_policy(PolicyArn=policy_arn)
    default_version_id = response['Policy']['DefaultVersionId']
    version_response = client.get_policy_version(
        PolicyArn=policy_arn,
        VersionId=default_version_id
    )
    return version_response['PolicyVersion']['Document']['Statement']


def generate_report(role: str, aliases: dict) -> str:
    """ Generate JSON text of all policies within an IAM ROLE.
        Apply all aliases to remove sensitive data """

    client = boto3.client('iam')
    policy_map: dict = defaultdict(lambda: defaultdict(dict))

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

    return json_text


def main():
    parser = ArgumentParser(description="Export IAM policies for a given role and account")
    parser.add_argument("environment", help="Environment name (e.g. dev, pre-prod, prod, test)")
    parser.add_argument("role", help="Role to export")
    parser.add_argument("aliases", nargs='*',
                        help="A list of aliases to apply. E.g. 123456789012=prod_account")
    args = parser.parse_args()
    alias_map = {alias.split('=')[0]: alias.split('=')[1] for alias in args.aliases}
    contents = generate_report(args.role, alias_map)

    with open(f"infrastructure/iam_roles/{args.environment}_{args.role}.json", "w") as f:
        f.write(contents)


if __name__ == "__main__":
    main()
