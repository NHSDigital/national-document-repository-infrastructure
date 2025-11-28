default: help

help: ## This help message
	@grep -E --no-filename '^[a-zA-Z-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-42s\033[0m %s\n", $$1, $$2}'

.PHONY: Install
install:	## Run NPM install
	cd ./infrastructure && npm install

# Formatting
.PHONY:format-all
format-all:	## Format all terraform
	terraform fmt -recursive .

# Documentation
.PHONY:generate-terraform-docs
generate-terraform-docs: ## Generate terraform documentation
	./scripts/run_terraform_docs.py

# Installing
.PHONY:build-sandbox
build-sandbox: ## Build a sandbox using either the branch as the workspace name, sanitised, or pass in a name for the workspace e.g. make build-sandbox WORKSPACE=my-workspace . By default only a plan will run unless APPLY=true is used.
	WORKSPACE=$(WORKSPACE) APPLY=$(APPLY) ./scripts/build_sandbox.sh
# Linting

# Testing

# Bootstrap
.PHONY: init-bootstrap
init-bootstrap: ## Run Bootstrap terraform
	cd ./bootstrap && terraform init

.PHONY: apply-bootstrap
apply-bootstrap:	## Apply Bootstrap terraform
	cd ./bootstrap && terraform apply


# Export current github role permissions
# Pass in an aliases variable containing account IDs you need to mask.
# e.g. make export-dev-github-role aliases="123456789012=account 555555555555=other_account"
.PHONY: export-dev-github-role
export-dev-github-role: ## Export DEV github role permissions. Account IDs can be masked by passing in a list of aliases. E.g. make export-dev-github-role aliases="123456789012=account 555555555555=other_account"
	python ./scripts/export_role_policies.py dev github-actions-dev-role ${aliases}

.PHONY: export-pre-prod-github-role
export-pre-prod-github-role: ## See above
	python ./scripts/export_role_policies.py pre-prod Github-Actions-pre-prod-role ${aliases}

.PHONY: export-prod-github-role
export-prod-github-role: ## See above
	python ./scripts/export_role_policies.py prod github-access-role ${aliases}

.PHONY: export-test-github-role
export-test-github-role: ## See above
	python ./scripts/export_role_policies.py test github-action-role ${aliases}