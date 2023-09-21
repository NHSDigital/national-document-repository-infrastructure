#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

eval "$(jq -r '@sh "DYNAMO_ENV=\(.dynamo_env)"')" || DYNAMO_ENV=""

ARF_TABLE="$(terraform workspace show)_DocumentReferenceMetadata"
LG_TABLE="$(terraform workspace show)_LloydGeorgeReferenceMetadata"

if [ "$DYNAMO_ENV" = "lloydGeorge" ]; then
      jq -n --arg arf_table "$ARF_TABLE" \
            --arg lg_table "$LG_TABLE" \
            '{"DOCUMENT_STORE_DYNAMODB_NAME":$arf_table, "LLOYD_GEORGE_DYNAMODB_NAME":$lg_table}'
else
      jq -n --arg arf_table "$ARF_TABLE" \
            '{"DOCUMENT_STORE_DYNAMODB_NAME":$arf_table}'
fi

