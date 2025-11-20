"""
Generate a JSON dump of IAM permissions for a given role.
"""

import json
import re

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


def main(account, role):
    client = boto3.client('iam')
    policy_map = defaultdict(lambda: defaultdict(dict))

    # Get inline policies for the role
    for policy_name in list_role_policies(client, role):
        permissions = get_role_policy(client, role, policy_name)
        policy_map['inline'][policy_name] = permissions

    # # Get attached policies for the role
    for attached_policy in list_attached_role_policies(client, role):
        policy_name = attached_policy['PolicyName']
        policy_arn = attached_policy['PolicyArn']
        permissions = get_attached_role_policy(client, policy_arn)
        policy_map['attached'][policy_name] = permissions

    json_text = json.dumps(policy_map, indent=2)
    print(re.sub(account, "${account_id}", json_text))


if __name__ == "__main__":
    parser = ArgumentParser(description="Export IAM policies for a given role and account")
    parser.add_argument("account", help="Account ID to replace in output with ${account_id}")
    parser.add_argument("role", help="Role to export")
    args = parser.parse_args()
    main(args.account, args.role)
