import json
import time
import boto3, os, requests, sys

from botocore.exceptions import ClientError


def trigger_delete_workflow(token: str, git_ref: str, sandbox: str):
    owner = "NHSDigital"
    repo = "national-document-repository-infrastructure"
    workflow = "tear-down-sandbox.yml"

    url = f"https://api.github.com/repos/{owner}/{repo}/actions/workflows/{workflow}/dispatches"
    headers = {
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {token}",
        "X-GitHub-Api-Version": "2022-11-28",
    }

    inputs = {
        "git_ref": git_ref,
        "sandbox_name": sandbox,
        "environment": "development",
    }

    resp = requests.post(
        url, headers=headers, json={"ref": "main", "inputs": inputs}
    )
    resp.raise_for_status()


def get_workspaces() -> list[str]:
    client = boto3.client("appconfig")
    try:
        applications = client.list_applications().get("Items")
        if not applications:
            print("Failed to extract AppConfig applications")
            sys.exit(0)

        workspaces = []
        for application in applications:
            name = application.get("Name")
            if not name:
                print("Failed to extract TF workspace from AppConfig application")
                sys.exit(1)
            
            if name.startswith("RepositoryConfiguration-"):
                workspaces.append(name.replace("RepositoryConfiguration-", ""))
        return workspaces
    except ClientError as e:
        print(f"Failed to extract TF workspace from AppConfig applications: {str(e)}")
        sys.exit(1)

def get_workspace_git_ref(sandbox: str) -> str:
    client = boto3.client("appconfig")
    application_name = f"RepositoryConfiguration-{sandbox}"
    config_profile_name = f"config-profile-{sandbox}"
    git_ref = "main"

    try:
        applications = client.list_applications().get("Items")
        application_id = None
        for application in applications:
            if application.get("Name") == application_name:
                application_id = application.get("Id")
                break
        
        if not application_id:
            return git_ref

        configuration_profiles = client.list_configuration_profiles(
            ApplicationId=application_id
        ).get("Items")

        for config_profile in configuration_profiles:
            if config_profile.get("Name") == config_profile_name:
                profileId = config_profile.get("Id")

                session_response = client.start_configuration_session(
                    ApplicationIdentifier=application_id,
                    EnvironmentIdentifier=sandbox,
                    ConfigurationProfileIdentifier=profileId
                )
                initial_token = session_response['InitialConfigurationToken']

                # Get latest configuration
                config_response = client.get_latest_configuration(
                    ConfigurationToken=initial_token
                )

                # Parse configuration content
                config_content = config_response['Configuration'].read()
                config_data = json.loads(config_content)

                # Extract gitRef
                git_ref=config_data.get('versionNumberEnabled', {}).get('gitRef')

        return git_ref

    except ClientError:
        return git_ref


if __name__ == "__main__":
    gh_pat = os.getenv("GIT_WORKFLOW_PAT")
    if not gh_pat:
        sys.exit("GIT_WORKFLOW_PAT not set")

    #Add persisting environments here
    excluded = ["ndr-dev"]

    workspaces = get_workspaces()
    for workspace in workspaces:
        if workspace not in excluded:
            git_ref = get_workspace_git_ref(workspace)
            trigger_delete_workflow(token=gh_pat, git_ref=git_ref, sandbox=workspace)
            time.sleep(300) # Wait 5 min between executions to avoid an AWS concurrency issue.
