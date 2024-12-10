# National Document Repository Infrastructure

## Prerequisites

Ensure the following Prereqs are installed:

1. [Terraform Docs](https://terraform-docs.io/) - For formatting Terraform documentation:

    If using Windows:

    ```bash
    chocolatey install terraform-docs
    ```

    If using Mac:

    ```bash
    brew install terraform-docs
    ```

    If using Linux/WSL:

    - Install precompiled binary: - (this documentation assumes latest version is `v0.19.0`) - latest binary can be found here <https://github.com/terraform-docs/terraform-docs/releases>

        ```bash
        curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.19.0/terraform-docs-v0.19.0-$(uname)-amd64.tar.gz
        tar -xzf terraform-docs.tar.gz
        chmod +x terraform-docs
        ```

    - Add to your $PATH (replace `YOURUSERNAME` with your linux username):

        ```bash
        mv terraform-docs /home/YOURUSERNAME/.local/bin/terraform-docs
        ```

    - Verify this has worked with:

        ```bash
        whereis terraform-docs
        ```

    - Make sure that the line endings on the `create-terraform-docs.sh` script are in UNIX format by running:

        ```bash
        cd scripts
        dos2unix create-terraform-docs.sh
        ```

2. [findutils](https://www.gnu.org/software/findutils/) - *If running on MacOSX*

    ```bash
    brew install findutils
    ```

## Repository best practices

We provide a `makefile` to ensure consistency and provide simplicity. It is strongly advised, both when planning and applying Terraform, that this is done via the `makefile`.

The `make pre-commit` command will format all Terraform code, and re-create all `README.md` files. This should be run before every commit to keep the code base clean.

## Using Workspaces

To initialise the S3 backend:

```bash
cd infrastructure/
terraform init -backend-config=backend.conf
```

### The makefile

The following commands currently exist in the `makefile`:

- `make pre-commit` -> runs both the `make generate-docs` and `make format-all` commands.

### Deploying to a new AWS Account

The details on how to run this Terraform process on a new AWS account can be found on our [Confluence guide](https://gpitbjss.atlassian.net/wiki/spaces/TW/pages/12581568619/Infrastructure+-+Deploy+to+a+new+Account).

## Troubleshooting

### Resolving "Error: Error acquiring the state lock" for Sandboxes

If a manual or CRON destroy fails and results in a state lock, follow these steps to resolve the issue:

#### Step 1: Check for Recovery Points

1. Log in to the AWS console.
1. Navigate to `AWS Backup -> Vaults`.
1. Confirm there are no `Recovery points` associated with the sandbox environment you're trying to destroy.
1. If any recovery points exist, manually delete them.

> [!WARNING]
> Terraform destroy will **fail** if recovery points are not deleted.

#### Step 2: Export AWS Credentials

Copy your AWS account environment variables (e.g. `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, etc.) from the AWS console into a terminal session.

> [!IMPORTANT]
> Ensure the credentials match the environment you're troubleshooting.

#### Step 3: Retrieve the State Lock ID

1. Open the GitHub Actions console for the failed Terraform workflow.
1. Locate the `Lock Info` details in the error message output. Example:

    ```text
    Error message: ConditionalCheckFailedException: The conditional request
    │ failed
    │ Lock Info:
    │   ID:        XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
    │   Path:      {workspace}-terraform-state-***/env:/{workspace}/ndr/terraform.tfstate
    │   Operation: OperationTypeApply
    │   Who:       runner@fv-az881-525
    │   Version:   1.5.4
    │   Created:   2024-11-21 18:00:48.11675513 +0000 UTC
    │   Info:
    ```

#### Step 4: Force Unlock the State

1. Open a terminal where your AWS credentials are configured.
1. Run the following commands, replacing `<workspace>` and `<Lock Info ID>` with the appropriate values:

    ```bash
    cd infrastructure/
    terraform workspace select <workspace>
    terraform force-unlock <Lock Info ID>
    ```

> [!IMPORTANT]
> When prompted, type `yes` to confirm the unlock.

#### Step 5: Re-run the failed Terraform Destroy Workflow through GitHub Actions
