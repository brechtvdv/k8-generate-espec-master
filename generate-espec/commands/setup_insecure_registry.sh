#!/usr/bin/env bash
INFLUX_NAME=influxdb
MANIFEST_FILE=manifest.xml

INFLUX_HOSTNAME=$(xmllint --xpath "string(/*[local-name()='rspec']/*[local-name()='node'][@client_id='$INFLUX_NAME']/*[local-name()='host']/@name)" $MANIFEST_FILE)
echo '{"insecure-registries": ["'${INFLUX_HOSTNAME}:5000'"]}' > /etc/docker/daemon.json

service docker restart