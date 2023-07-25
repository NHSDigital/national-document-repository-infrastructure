default: help

.PHONY: init-bootstrap
init-bootstrap:
	cd ./bootstrap && terraform init

.PHONY: apply-bootstrap
apply-bootstrap:
	cd ./bootstrap && terraform apply


# Bootstrap

# Pre-commit husky

# Pre-push husky

# Formatting

# Installing

# Linting

# Testing