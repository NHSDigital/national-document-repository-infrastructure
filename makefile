default: help

# Bootstrap
.PHONY: init-bootstrap
init-bootstrap:
	cd ./bootstrap && terraform init

.PHONY: apply-bootstrap
apply-bootstrap:
	cd ./bootstrap && terraform apply

# Pre-commit husky
.PHONY:pre-commit
pre-commit:  generate-terraform-docs format-all

# Pre-push husky

# Formatting
.PHONY:format-all
format-all:
	terraform fmt -recursive .

# Documentation
.PHONY:generate-terraform-docs
generate-terraform-docs:
	./supporting_scripts/create-terraform-docs.sh

# Installing

# Linting

# Testing