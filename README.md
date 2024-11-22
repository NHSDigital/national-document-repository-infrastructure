# National Document Repository Infrastructure

## Prerequisites

Ensure the following Prereqs are installed first (can use brew on Mac/Linux or Chocolatey on Windows)

- [Terraform Docs](https://terraform-docs.io/) - for formatting Terraform documentation

    ```bash
    brew install terraform-docs
    ```

- [findutils](https://www.gnu.org/software/findutils/) - Needed for scripts running on MacOSX

    ```bash
    brew install findutils
    ```

## Repository best practices

We provide a `makefile` to ensure consistency and provide simplicity. It is strongly advised, both when planning and applying Terraform, that this is done via the `makefile`.

The `make pre-commit` command this will format all Terraform code, and re-create all `README.md` files. This should be run before every commit to keep the code base clean.

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

### Error acquiring the state lock for a Sandbox

For sandboxes that fail on a manual or a CRON destroy and result in a state lock:

1. Login to the AWS console go to `AWS Backup -> Vaults` and make sure there are no `Recovery points` associated with the environment you're trying to destroy. If there are any, manually delete these first otherwise the Terraform destroy WILL FAIL.
1. Copy your AWS account environment variables from the AWS console into a terminal.
1. Retrieve the state lock ID from the GitHub Actions console output related to the Terraform workspace which failed e.g.:

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

1. In the a terminal with your exported AWS credentials:

    ```bash
    cd infrastructure/
    terraform workspace select {workspace}
    terraform force-unlock {Lock Info ID}
    ```

    > Select `yes` when prompted.
1. Re-run the Terraform destroy workflow.
