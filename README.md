# National Document Repository Infrastructure 



## Prerequisite
Ensure the following Prereqs are installed first (can use brew on Mac/Linux or Chocolatey on Windows)
- [Terraform Docs](https://terraform-docs.io/) - for formatting terraform documentation
```bash
brew install terraform-docs
```
- [findutils](https://www.gnu.org/software/findutils/) - Needed for scripts running on MacOSX
```bash
brew install findutils
```

## Repository best practices

We provide a makefile to ensure consistency and provide simplicity. It is strongly advised, both when planning and applying terraform, that this is done via the makefile.

The `make pre-commit` command this will format all terraform code, and re-create all README.md files. This should be run before every commit to keep the code base clean.

## Using Workspaces
To initialise the S3 backend, cd to infrastructure folder and run 
```bash
terraform init -backend-config=backend.conf
```

### The makefile

The following commands currently exist in the make file:

- `make pre-commit` -> runs both the `make generate-docs` and `make format-all` commands.


### Deploying to a new AWS Account

The details on how to run this terraform process on a new AWS account can be found on our confluence guides found [here](https://gpitbjss.atlassian.net/wiki/spaces/TW/pages/12581568619/Infrastructure+-+Deploy+to+a+new+Account)

## Troubleshooting

### Error acquiring the state lock for a Sandbox
For sandboxes that fail on a manual or a CRON destroy and result in a state lock:
- Login to the AWS console go to `AWS Backup -> Vaults` and make sure there are no `Recovery points` associated with the environment you're trying to destroy. If there are any, manually delete these first otherwise the terraform destroy WILL FAIL.
- Copy your AWS account environment variables from the AWS console into a terminal
- Retrieve the state lock ID from the github actions console output related to the terraform workspace which failed:
```
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
- In the a terminal with your exported AWS credentials:
  - Change directory to the `/terraform` folder
  - Run `terraform workspace select {workspace}`
  - Run `terraform force-unlock {Lock Info ID}` and select `yes` when prompted
- Re-run the tf destroy workflow
