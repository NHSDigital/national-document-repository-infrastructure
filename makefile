default: help

help: ## This help message
	@grep -E --no-filename '^[a-zA-Z-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-42s\033[0m %s\n", $$1, $$2}'

.PHONY: \
	Install
	format-all
	generate-terraform-docs
	build-sandbox
	init-bootstrap
	apply-bootstrap
	export-dev-github-role
	export-pre-prod-github-role
	export-prod-github-role
	export-test-github-role
	create-csrs

install:	## Run NPM install
	cd ./infrastructure && npm install

# Formatting
format-all:	## Format all terraform
	terraform fmt -recursive .

# Documentation
generate-terraform-docs: ## Generate terraform documentation
	./scripts/run_terraform_docs.py

# Installing
build-sandbox: ## Build a sandbox using either the branch as the workspace name, sanitised, or pass in a name for the workspace e.g. make build-sandbox WORKSPACE=my-workspace . By default only a plan will run unless APPLY=true is used.
	WORKSPACE=$(WORKSPACE) APPLY=$(APPLY) ./scripts/build_sandbox.sh

# Bootstrap
init-bootstrap: ## Run Bootstrap terraform
	cd ./bootstrap && terraform init

apply-bootstrap:	## Apply Bootstrap terraform
	cd ./bootstrap && terraform apply

# Export current github role permissions
# Pass in an aliases variable containing account IDs you need to mask.
# e.g. make export-dev-github-role aliases="123456789012=account 555555555555=other_account"
export-dev-github-role: ## Export DEV github role permissions. Account IDs can be masked by passing in a list of aliases. E.g. make export-dev-github-role aliases="123456789012=account 555555555555=other_account"
	python ./scripts/export_role_policies.py dev github-actions-dev-role ${aliases}

export-pre-prod-github-role: ## See above
	python ./scripts/export_role_policies.py pre-prod Github-Actions-pre-prod-role ${aliases}
 
export-prod-github-role: ## See above
	python ./scripts/export_role_policies.py prod github-access-role ${aliases}

export-test-github-role: ## See above
	python ./scripts/export_role_policies.py test github-action-role ${aliases}`

# Create Certificate Signing Requests
create-csrs: ## Create CSRs for all environments. This will create a key and CSR for each environment and place them in the keys and csrs folders respectively.
	cd ./scripts && ./create_csrs.sh
