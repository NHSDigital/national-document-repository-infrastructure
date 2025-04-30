from os import environ
import boto3
import subprocess
import sys

workspace = sys.argv[1]
environment = sys.argv[2]

tfvars_files = {
    "development": "dev.tfvars",
    "test": "test.tfvars",
    "pre-prod": "preprod.tfvars",
    "prod": "prod.tfvars",
}


def get_policy_arn(policy_name):
    client = boto3.client("iam")

    policies = [
        policy
        for page in client.get_paginator("list_policies").paginate(Scope="All")
        for policy in page["Policies"]
    ]

    for policy in policies:
        print(policy)

    policy_arn = next(
        (policy["Arn"] for policy in policies if policy["PolicyName"] == policy_name),
        None,
    )
    return policy_arn

    return None


def import_to_terraform(arn, resource_name):
    tfvars = tfvars_files[environment]
    tf_vars_cmd = f"-var-file={tfvars}"
    subprocess.run(
        ["terraform", "import", tf_vars_cmd, f"aws_iam_policy.{resource_name}", arn], check=True
    )


if __name__ == "__main__":
    policy_name = (
        f"{workspace}_ssm_public_token_policy"  # Replace with your desired policy name
    )
    arn = get_policy_arn(policy_name)
    if arn:
        print(f"Policy ARN: {arn}")
        import_to_terraform(
            arn, "ssm_policy_authoriser"
        )  # Replace with your Terraform resource name
    else:
        print(f"Policy '{policy_name}' not found.")
