# Terraform Readme

## Pre-requisites

- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Terraform docs](https://github.com/terraform-docs/terraform-docs)

## Installation

### pre-commit hook

As this repository is a standalone infrastructure there is no python/node based pre-commit. Therefore the commit is run but itself. This means that you need to tell git where pre-commits are run from.

- Set this repository to get it's pre-commit hooks from .githooks

```
git config core.hooksPath .githooks
```

Pre-commits will run on any commit. This will build docs and format the terraform.
