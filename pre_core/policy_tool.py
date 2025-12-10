import json
import os
import subprocess
import sys


def get_policy_names(env, role_name):
    filename = f"../infrastructure/iam_roles/{env}_{role_name}.json"
    with open(filename, 'r') as file:
        policies = json.load(file)
        attached_policies = [p for p in policies["attached"] if p != "ReadOnlyAccess"]
    return sorted(attached_policies)


def create_dummy_resources(env, policy_names):
    filename = f"dummy_import_{env}.tf"
    with open(filename, 'w') as file:
        file.write(f'resource "aws_iam_role" "github_role_{env}" {{\n')
        file.write(f'    count = var.environment == "{env}" ? 1 : 0\n')
        file.write('}\n\n')

        for policy_name in policy_names:
            file.write(f'resource "aws_iam_policy" "{policy_name.replace("-", "_")}_{env}" {{\n')
            file.write(f'    count = var.environment == "{env}" ? 1 : 0\n')
            file.write('}\n\n')


def run_command(command):
    print(f"Running command: {command}")
    result = os.system(command)
    if result != 0:
        print(f"Command failed with exit code {result}")
        sys.exit(result)


def import_resources(aws_account_id, env, role_name, policy_names):
    run_command(f'terraform import -var environment={env} -var aws_account_id={aws_account_id} aws_iam_role.github_role_{env}[0] {role_name}')
    for policy_name in policy_names:
        resource_name = policy_name.replace("-", "_")
        run_command(f'terraform import -var environment={env} -var aws_account_id={aws_account_id} aws_iam_policy.{resource_name}_{env}[0] arn:aws:iam::{aws_account_id}:policy/{policy_name}')


def tidy_resource_file(aws_account_id, env, source):
    ignore_lines = [
    "arn",
    "attachment_count",
    "policy_id",
    "id",
    "create_date",
    "unique_id",
]
    output = []
    for line in source.split("\n"):
        if [i for i in ignore_lines if f" {i} " in line]:
            continue

        if line.startswith("resource "):
            output.append(line.rstrip())
            output.append(f'    count = var.environment == "{env}" ? 1 : 0')
            continue

        # line = line.replace(aws_account_id, "${var.aws_account_id}")
        output.append(line.replace(aws_account_id, "${var.aws_account_id}"))

    return "\n".join(output)


def generate_tf_file(aws_account_id, env, role_name, policy_names):
    filename = f"imported_{env}.tf.txt"
    with open(filename, 'w') as file:
        command = f"terraform state show -no-color aws_iam_role.github_role_{env}[0]"
        result = subprocess.run(command.split(" "), stdout=subprocess.PIPE).stdout.decode('utf-8')
        file.write(f"{tidy_resource_file(aws_account_id, env, result)}\n\n")

        for policy_name in policy_names:
            command = f"terraform state show -no-color aws_iam_policy.{policy_name.replace('-', '_')}_{env}[0]"
            result = subprocess.run(command.split(" "), stdout=subprocess.PIPE).stdout.decode('utf-8')
            file.write(f"{tidy_resource_file(aws_account_id, env, result)}\n\n")




command, aws_account_id, env, role_name = sys.argv[1:]
print(f"AWS Account ID: {aws_account_id}")
print(f"Command: {command}")

if command == "import":
    print("Importing policies...")
    policy_names = get_policy_names(env, role_name)
    print(policy_names)
    if not os.path.exists(f"dummy_import_{env}.tf") and not os.path.exists(f"iam_github_{env}.tf"):
        create_dummy_resources(env, policy_names)
    import_resources(aws_account_id, env, role_name, policy_names)

if command == "generate-tf-file":
    print("Generating TF file...")
    policy_names = get_policy_names(env, role_name)
    print(policy_names)
    generate_tf_file(aws_account_id, env, role_name, policy_names)