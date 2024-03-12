#!/bin/sh

dockerfile_path="Dockerfile"  # Can change this to the path of your Dockerfile

# This can be parsed for entrypoint or CMD. Entrypoint will be overriden in case both are present (To be worked on)
# Extract the ENTRYPOINT line from the Dockerfile
entrypoint_line=$(grep -m 1 '^ENTRYPOINT ' "$dockerfile_path")

# Extract only the command part and remove square brackets
entrypoint_command=$(echo "$entrypoint_line" | sed 's/^ENTRYPOINT //' | tr -d '[]')

# Replacing variables with values (if any)
entrypoint_command=$(eval echo "$entrypoint_command")

# Remove leading and trailing whitespaces
entrypoint_command=$(echo "$entrypoint_command" | awk '{$1=$1};1')

# Remove commas from the command
entrypoint_command=$(echo "$entrypoint_command" | tr -d ',')

# echo "Reconstructed command: $entrypoint_command"

# Can do whatever tasks we want to do here
# Getting keploy custom CAs
curl -o ca.crt https://raw.githubusercontent.com/keploy/keploy/main/pkg/proxy/asset/ca.crt
curl -o setup_ca.sh https://raw.githubusercontent.com/keploy/keploy/main/pkg/proxy/asset/setup_ca.sh
# Give execute permission to the setup_ca.sh script
chmod +x setup_ca.sh

# Executing the actual entrypoint command of the application
exec $entrypoint_command