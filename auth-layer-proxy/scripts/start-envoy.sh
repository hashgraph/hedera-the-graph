#!/bin/sh

# Set default values for environment variables if they are not already set
export SERVICE_TYPE=${SERVICE_TYPE:-LOGICAL_DNS}
export SERVICE_ADDRESS=${SERVICE_ADDRESS:-host.docker.internal}
export SERVICE_PORT=${SERVICE_PORT:-8020}
export ENVOY_ADMIN_PORT=${ENVOY_ADMIN_PORT:-15000}
export PROXY_PORT=${PROXY_PORT:-10000}
export CLIENT_ID=${CLIENT_ID:-htg-auth-layer}
export TOKEN_INTROSPECTION_URL=${TOKEN_INTROSPECTION_URL:-http://host.docker.internal:8080/realms/HederaTheGraph/protocol/openid-connect/token/introspect}

# print the environment variables
echo "----------------------------------------"
echo "---  Environment variables:          ---"
echo "----------------------------------------"
echo "SERVICE_TYPE: $SERVICE_TYPE"
echo "SERVICE_ADDRESS: $SERVICE_ADDRESS"
echo "SERVICE_PORT: $SERVICE_PORT"
echo "ENVOY_ADMIN_PORT: $ENVOY_ADMIN_PORT"
echo "PROXY_PORT: $PROXY_PORT"
echo "CLIENT_ID: $CLIENT_ID"
echo "CLIENT_SECRET: $CLIENT_SECRET"
echo "TOKEN_INTROSPECTION_URL: $TOKEN_INTROSPECTION_URL"
echo "----------------------------------------"


# Use envsubst to replace environment variables in the template
envsubst < /etc/envoy/configs/envoy-auth-template.yaml > /etc/envoy/envoy-config.yaml

# Print the processed configuration
echo "----------------------------------------"
echo "---  Processed Envoy configuration:  ---"
echo "----------------------------------------"
cat /etc/envoy/envoy-config.yaml
echo "----------------------------------------"

# Now start Envoy with the processed configuration
envoy -c /etc/envoy/envoy-config.yaml
