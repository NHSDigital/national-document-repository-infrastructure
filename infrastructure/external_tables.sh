#!/bin/sh

# env.sh

$WORKSPACE = $(terraform workspace show)
cat <<EOF
{
  "DYNAMODB_DOCUMENT_STORE": "ndra_DocumentReferenceMetadata",
  "DYNAMODB_LLOYD_GEORGE": "ndra_LloydGeorgeReferenceMetadata"
}
EOF