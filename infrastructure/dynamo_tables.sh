#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

eval "$(jq -r '@sh "DYNAMO_ENV=\(.dynamo_env)"')" || DYNAMO_ENV=""

ARF_TABLE="$(terraform workspace show)_DocumentReferenceMetadata"
LG_TABLE="$(terraform workspace show)_LloydGeorgeReferenceMetadata"


if [ "$DYNAMO_ENV" = "lloydGeorge" ]; then
      jq -n --arg arf_table "$ARF_TABLE" \
            --arg lg_table "$LG_TABLE" \
            '{"ARF_DYNAMO_TABLE":$arf_table, "LG_DYNAMO_TABLE":$lg_table}'
else
      jq -n --arg arf_table "$ARF_TABLE" \
            '{"ARF_DYNAMO_TABLE":$arf_table}'
fi

