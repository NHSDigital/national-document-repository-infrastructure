default: help

.PHONY: Install
install:
	cd ./infrastructure && npm install
	
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
# .PHONY:pre-push
# pre-commit: 

# Formatting
.PHONY:format-all
format-all:
	terraform fmt -recursive .

# Documentation
.PHONY:generate-terraform-docs
generate-terraform-docs:
	./scripts/create-terraform-docs.sh

# Installing

# Linting

# Testing