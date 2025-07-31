import sys

import boto3
from botocore.exceptions import ClientError


class CleanupLogGroups:

    def __init__(self):
        self.logs_client = boto3.client("logs")

    def main(self, sandbox: str):
        try:
            paginator = self.logs_client.get_paginator("describe_log_groups")
            log_groups_to_delete = []

            for page in paginator.paginate():
                for log_group in page.get("logGroups", []):
                    log_group_name = log_group["logGroupName"]
                    if sandbox in log_group_name:
                        log_groups_to_delete.append(log_group_name)

            if not log_groups_to_delete:
                print(f"No log groups found matching pattern: {sandbox}")
                return

            for log_group_name in log_groups_to_delete:
                print(f"Found log group: {log_group_name}")
                # try:
                #     self.logs_client.delete_log_group(logGroupName=log_group_name)
                #     print(f"Deleted log group: {log_group_name}")
                # except ClientError as e:
                #     print(f"Failed to delete log group {log_group_name}: {e}")

        except ClientError as e:
            print(f"Error during log group cleanup: {e}")


if __name__ == "__main__":
    sandbox = sys.argv[1]
    exclude_list = ["ndr-dev"]

    if sandbox in exclude_list:
        print("Cleanup log groups. Cannot delete protected environment")
        sys.exit(1)

    print(f"Attempting to cleanup the log_groups for: {sandbox}")
    CleanupLogGroups().main(sandbox=sandbox)
