#!/bin/sh
# Use envsubst to replace environment variables in the template
envsubst < /etc/envoy/configs/envoy-auth-template.yaml > /etc/envoy/envoy-config.yaml
# cat /etc/envoy/envoy-config.yaml
cat /etc/envoy/envoy-config.yaml
# Now start Envoy with the processed configuration
envoy -c /etc/envoy/envoy-config.yaml
