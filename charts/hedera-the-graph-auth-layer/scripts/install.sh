#!/bin/bash

# Verify params
if [ -z "$1" ]; then
  echo "Missing required parameter: <release-name>"
  exit 1
fi

# Set release name
RELEASE_NAME=$1

# Define the character set for CLIENT_SECRET
CHARS="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

# Desired length of the random string
LENGTH=32

# Initialize CLIENT_SECRET variable
CLIENT_SECRET=""

for i in $(seq 1 $LENGTH); do
  CLIENT_SECRET="$CLIENT_SECRET${CHARS:RANDOM%${#CHARS}:1}"
done

# Prepare the base Helm command
HELM_COMMAND="helm install $RELEASE_NAME . --set global.auth.clientSecret=\"$CLIENT_SECRET\""

# Process remaining arguments
shift # Skip the first argument since it's the release name

while (( "$#" )); do
  case "$1" in
    -f)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        # Add the file argument with quotes around the file name
        HELM_COMMAND+=" -f \"$2\""
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    --set)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        # Split the --set argument into key and value, assuming they're in the form key=value
        IFS='=' read -ra KV <<< "$2"
        # Add the --set argument with quotes around the value part
        HELM_COMMAND+=" --set ${KV[0]}=\"${KV[1]}\""
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    *)
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
  esac
done

# Execute the Helm command
echo "Executing: $HELM_COMMAND"
eval $HELM_COMMAND
