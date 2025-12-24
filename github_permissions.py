import re
from collections import defaultdict

import boto3

ROLE = "github-access-role"  # Test Account
ACCOUNT = "487224344892"


def list_role_policies(client, role_name):
    inline_policies = []
    paginator = client.get_paginator("list_role_policies")
    for page in paginator.paginate(RoleName=role_name):
        inline_policies.extend(page["PolicyNames"])
    return inline_policies


def get_role_policy(client, role_name, policy_name):
    response = client.get_role_policy(RoleName=role_name, PolicyName=policy_name)
    return response["PolicyDocument"]["Statement"]


def list_attached_role_policies(client, role_name):
    attached_policies = []
    paginator = client.get_paginator("list_attached_role_policies")
    for page in paginator.paginate(RoleName=role_name):
        attached_policies.extend(page["AttachedPolicies"])
    return attached_policies


def get_attached_role_policy(client, policy_arn):
    response = client.get_policy(PolicyArn=policy_arn)
    default_version_id = response["Policy"]["DefaultVersionId"]
    version_response = client.get_policy_version(
        PolicyArn=policy_arn, VersionId=default_version_id
    )
    return version_response["PolicyVersion"]["Document"]["Statement"]


def add_permissions_to_map(permission_map, permissions, policy_name, arn="inline"):
    for permission in permissions:
        name = f"{policy_name} | {arn} | {permission.get('Sid','N/A')}"
        effect = permission.get("Effect", "N/A")
        actions = permission.get("Action", [])
        if not isinstance(actions, list):
            actions = [actions]
        for action in actions:
            resources = permission.get("Resource", [])
            if not isinstance(resources, list):
                resources = [resources]
            for resource in resources:
                key = (effect, action, resource)
                permission_map[key].append(name)


def main():
    """Generate a map of effect|action|resource to see how many policies grant the same permissions"""

    client = boto3.client("iam")
    permission_map = defaultdict(list)

    # Get inline policies for the role
    inline_policies = list_role_policies(client, ROLE)
    for policy_name in inline_policies:
        permissions = get_role_policy(client, ROLE, policy_name)
        add_permissions_to_map(permission_map, permissions, policy_name)

    # Get attached policies for the role
    for attached_policy in list_attached_role_policies(client, ROLE):
        policy_name = attached_policy["PolicyName"]
        policy_arn = attached_policy["PolicyArn"]
        permissions = get_attached_role_policy(client, policy_arn)
        add_permissions_to_map(permission_map, permissions, policy_name, policy_arn)

    for key in sorted(permission_map):
        policies = permission_map[key]
        effect, action, resource = key
        output = f"{effect}\t{action}\t{resource}\t{policies}"
        print(re.sub(ACCOUNT, "{ ACCOUNT }", output))


if __name__ == "__main__":
    main()
