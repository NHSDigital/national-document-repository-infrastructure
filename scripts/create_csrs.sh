#!/bin/bash

# This is for generating certs used during mTLS authentication.
# Taken from https://github.com/NHSDigital/api-management-cert-generation/blob/master/README.md
# This script is likely needed if certificates need to be regenerated due to expiry or if new environments are added etc.
# Run create_csrs.sh to generate keys into keys/ and CSRs into csrs/ to send to a trusted CA.
# Usage:
# ./create_csrs.sh

set -euo pipefail

mkdir -p csrs/core
mkdir -p csrs/lloyd_george
mkdir -p keys/core
mkdir -p keys/lloyd_george

openssl req -new -newkey rsa:4096 -nodes -sha256 -keyout keys/core/dev.api.service.nhs.uk.key -out csrs/core/dev.api.service.nhs.uk.csr -config confs/core/dev.conf -extensions v3_req
openssl req -new -newkey rsa:4096 -nodes -sha256 -keyout keys/core/test.api.service.nhs.uk.key -out csrs/core/test.api.service.nhs.uk.csr -config confs/core/test.conf -extensions v3_req
openssl req -new -newkey rsa:4096 -nodes -sha256 -keyout keys/core/preprod.api.service.nhs.uk.key -out csrs/core/preprod.api.service.nhs.uk.csr -config confs/core/preprod.conf -extensions v3_req
openssl req -new -newkey rsa:4096 -nodes -sha256 -keyout keys/core/api.service.nhs.uk.key -out csrs/core/api.service.nhs.uk.csr -config confs/core/prod.conf -extensions v3_req

openssl req -new -newkey rsa:4096 -nodes -sha256 -keyout keys/lloyd_george/dev.api.service.nhs.uk.key -out csrs/lloyd_george/dev.api.service.nhs.uk.csr -config confs/lloyd_george/dev.conf -extensions v3_req
openssl req -new -newkey rsa:4096 -nodes -sha256 -keyout keys/lloyd_george/test.api.service.nhs.uk.key -out csrs/lloyd_george/test.api.service.nhs.uk.csr -config confs/lloyd_george/test.conf -extensions v3_req
openssl req -new -newkey rsa:4096 -nodes -sha256 -keyout keys/lloyd_george/preprod.api.service.nhs.uk.key -out csrs/lloyd_george/preprod.api.service.nhs.uk.csr -config confs/lloyd_george/preprod.conf -extensions v3_req
openssl req -new -newkey rsa:4096 -nodes -sha256 -keyout keys/lloyd_george/api.service.nhs.uk.key -out csrs/lloyd_george/api.service.nhs.uk.csr -config confs/lloyd_george/prod.conf -extensions v3_req
