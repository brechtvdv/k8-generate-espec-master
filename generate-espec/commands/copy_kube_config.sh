#!/usr/bin/env bash

MASTER_NAME=master
MANIFEST_FILE=manifest.xml
MASTER_HOSTNAME=$(xmllint --xpath "string(/*[local-name()='rspec']/*[local-name()='node'][@client_id='$MASTER_NAME']/*[local-name()='host']/@name)" $MANIFEST_FILE)
USER=$(xmllint --xpath "string(/*[local-name()='rspec']/*[local-name()='node'][@client_id='$MASTER_NAME']/*[local-name()='services']/*[local-name()='login']/@username)" $MANIFEST_FILE)

mkdir -p ~/.kube/

scp -oStrictHostKeyChecking=no $USER@$MASTER_HOSTNAME:~/.kube/config ~/.kube/config
