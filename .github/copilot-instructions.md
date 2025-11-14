# Copilot Instructions for National Document Repository Infrastructure

## Project Overview

- This repository provisions infrastructure for the National Document Repository (NDR) using Terraform. No application code is present—focus is on AWS resources and automation.
- Major components are organized in `infrastructure/` (core AWS resources, modules), `bootstrap/` (initial setup), and `backup-vault/` (backup-related infra).
- Each subdirectory may have its own `README.md` with module/resource details.

## Architecture & Patterns

- Infrastructure is modular: see `infrastructure/modules/` for reusable Terraform modules (e.g., `lambda`, `s3`, `dynamo_db`, `gateway`).
- Data flows and service boundaries are defined by AWS resources: S3 buckets for document storage, DynamoDB tables for metadata, Lambda functions for processing, API Gateway for access, and SNS/SQS for notifications.
- Naming conventions for resources and variables are consistent across environments (dev, test, pre-prod, prod) using tfvars files (e.g., `dev.tfvars`).
- Cross-account and backup strategies are implemented in `backup-vault/` and related Terraform files.

## Developer Workflows

- **Pre-commit hooks:** Must be enabled via `git config core.hooksPath .githooks`. These format Terraform and build docs automatically on commit.
- **Build/Deploy:** Use Terraform CLI. Always run `terraform init` before `terraform plan` and `terraform apply` in the relevant directory.
- **Documentation:** Run `terraform-docs` to generate module docs. See main `README.md` for install instructions.
- **Testing:** No automated tests in this repo; validation is via Terraform plan/apply and pre-commit formatting.

## Conventions & Integration

- All code, comments, and documentation must be public and non-confidential.
- Use inclusive language and avoid private NHSE data.
- Resource definitions reference official AWS Terraform modules and providers (see `infrastructure/README.md` for versions).
- External dependencies: AWS, Terraform, terraform-docs.
- For new modules, follow the structure and documentation style in `infrastructure/modules/`.

## Examples

- To add a new Lambda, create a module in `infrastructure/modules/lambda/` and reference it in the main `.tf` file.
- To update environment-specific settings, edit the appropriate tfvars file (e.g., `prod.tfvars`).
- For backup configuration, see `backup-vault/teraform/` and related `.tf` files.

## Key Files & Directories

- `infrastructure/` — main AWS resources and modules
- `bootstrap/` — initial setup and state management
- `backup-vault/` — cross-account and backup infra
- `.githooks/` — pre-commit scripts
- `README.md` — project overview and setup
- `infrastructure/README.md` — module/resource documentation

---

For questions, contact CODEOWNERS or refer to the main `CONTRIBUTING.md`.
