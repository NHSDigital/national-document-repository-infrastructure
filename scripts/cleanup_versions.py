import re
import sys

import boto3


class CleanupVersions:
    def __init__(self):
        self.lambda_client = boto3.client("lambda")
        self.appconfig_client = boto3.client("appconfig")
        self.environment = sys.argv[1]

    def start(self):
        self.delete_hosted_configuration_versions()
        self.delete_lambda_layer_versions()

    def get_app_config_application_id(self) -> str:
        current_applications = self.appconfig_client.list_applications()
        for app in current_applications["Items"]:
            if f"-{self.environment}" in app["Name"]:
                return app["Id"]

    def get_app_config_profile_id(self, application_id: str) -> str:
        config_profiles = self.appconfig_client.list_configuration_profiles(
            ApplicationId=application_id
        )
        for profile in config_profiles["Items"]:
            if f"-{self.environment}" in profile["Name"]:
                return profile["Id"]

    def get_hosted_configuration_versions(self):
        print(f"\nGathering AppConfig hosted configuration versions on {self.environment}...")
        application_id = self.get_app_config_application_id()
        config_profile_id = self.get_app_config_profile_id(application_id)

        current_hosted_configuration_versions = self.appconfig_client.list_hosted_configuration_versions(
            ApplicationId=application_id,
            ConfigurationProfileId=config_profile_id
        )

        return current_hosted_configuration_versions["Items"]


    def get_lambda_layer_versions(self):
        print("\nGathering Lambda Layer versions...")

    def delete_hosted_configuration_versions(self):
        excess_hosted_config_versions = self.get_hosted_configuration_versions()
        number_of_excess_versions = len(excess_hosted_config_versions)
        print(f"\n{number_of_excess_versions} hosted configuration versions require deletion")

        successful_deletes = []
        for version in excess_hosted_config_versions:
            print(f"\nDeleting configuration version '{version['VersionNumber']}'...")
            response = self.appconfig_client.delete_hosted_configuration_version(
                ApplicationId=version['ApplicationId'],
                ConfigurationProfileId=version['ConfigurationProfileId'],
                VersionNumber=version['VersionNumber']
            )
            if response["ResponseMetadata"]["HTTPStatusCode"] == 204:
                successful_deletes.append(response)

        if number_of_excess_versions:
            if len(successful_deletes) == number_of_excess_versions:
                print("\nSuccessfully deleted all excess hosted configuration versions")
            else:
                print("\nAll excess hosted configuration versions were not successfully deleted, please manually "
                      "remove these from AppConfig using the AWS console or using AWS CLI")

    def delete_lambda_layer_versions(self):
        self.get_lambda_layer_versions()


if __name__ == "__main__":
    cleanup_versions = CleanupVersions()
    cleanup_versions.start()
    print("\nCleanup Process Complete.")
