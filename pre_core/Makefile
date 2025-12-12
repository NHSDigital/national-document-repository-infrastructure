# var-file := $(account).tfvars

guard-%:
	@ if [ "${${*}}" = "" ]; then \
        echo "env var: $* not set"; \
        exit 1; \
    fi

clean:
	find . -type d -name .terraform -exec rm -rf "{}" \; 2>/dev/null || true
	find . -type d -name terraform.tfstate.d -exec rm -rf  "{}" \; 2>/dev/null || true
	find . -name .terraform.plan -type f -delete 2>/dev/null || true
	find . -name errored.tfstate -type f -delete 2>/dev/null || true
	find . -name .tfplan.exit -type f -delete 2>/dev/null || true
	find . -name external-vars.json -type f -delete 2>/dev/null || true
	find . -name terraform.tfstate -type f -delete 2>/dev/null || true

tf-format-check:
	terraform fmt -check -recursive

tf-format:
	terraform fmt --recursive

# init: guard-aws_account_id guard-env
# 	terraform init -var environment=${env} -var aws_account_id=${aws_account_id}

init:
# 	terraform init -var aws_account_id=${aws_account_id}
# 	terraform init -backend-config=backend.conf
	terraform init

plan: guard-env
# 	terraform workspace select -or-create ${workspace}
	terraform plan -out=tfplan -var environment=${env}

apply: guard-workspace
	terraform workspace select -or-create ${workspace}
	terraform apply tfplan


# TEMP FUNCTIONS

import-github-policies: guard-aws_account_id guard-env guard-role
	python policy_tool.py import ${aws_account_id} ${env} ${role}
	rm -f dummy_import_${env}.tf

generate-tf-file: guard-aws_account_id guard-env guard-role
	python policy_tool.py generate-tf-file ${aws_account_id} ${env} ${role}
	mv imported_${env}.tf.txt iam_github_${env}.tf
