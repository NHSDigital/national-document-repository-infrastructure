# National Document Repository Infrastructure

This repository is used to build the infrastructure the NDR. That is it's sole purpose. There is no functional code on this repository. Please read the Installation section carefully. You must configure git to use the pre-commit.

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
