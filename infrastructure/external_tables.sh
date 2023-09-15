#!/bin/sh

# env.sh

$WORKSPACE = $(terraform workspace show)
cat <<EOF
{
  "DOCUMENT_STORE_DYNAMODB_NAME": "$WORKSPACE_DocumentReferenceMetadata",
  "LLOYD_GEORGE_DYNAMODB_NAME": "$WORKSPACE_LloydGeorgeReferenceMetadata"
}
EOF