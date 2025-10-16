default: help

.PHONY: Install
install:
	cd ./infrastructure && npm install

# Formatting
.PHONY:format-all
format-all:
	terraform fmt -recursive .

# Documentation
.PHONY:generate-terraform-docs
generate-terraform-docs:
	./scripts/run_terraform_docs.py

# Installing

# Linting

# Testing

# Bootstrap
.PHONY: init-bootstrap
init-bootstrap:
	cd ./bootstrap && terraform init

.PHONY: apply-bootstrap
apply-bootstrap:
	cd ./bootstrap && terraform apply
