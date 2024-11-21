#!/bin/bash
apt update
apt install apache2-utils -y

# Ensure the script stops on errors
set -e

# Create directory structure for the registry
mkdir -p registry/{nginx/conf.d,auth}

# Check if configuration files exist before copying
if [[ -f ./registry.conf ]] && [[ -f ./additional.conf ]]; then
    cp ./registry.conf ./registry/nginx/conf.d/registry.conf
    cp ./additional.conf ./registry/nginx/conf.d/additional.conf
else
    echo "Error: Required configuration files (registry.conf or additional.conf) are missing."
    exit 1
fi

# Navigate to the auth directory
cd ./registry/auth

# Prompt user for a username and password
echo "Insert a Username:"
read username
if [[ -z "$username" ]]; then
    echo "Error: Username cannot be empty."
    exit 1
fi

# Create a password file using htpasswd
if ! command -v htpasswd &>/dev/null; then
    echo "Error: htpasswd command not found. Please install Apache HTTPD tools."
    exit 1
fi

htpasswd -Bc registry.passwd "$username"

# Return to the root directory and start the Docker Compose setup
cd ../..

echo "Creating container..."
if ! command -v docker-compose &>/dev/null; then
    echo "Error: Docker Compose not found. Please install Docker Compose."
    exit 1
fi

docker compose up -d

# Display the contents of the howto.txt file, if it exists
if [[ -f ./howto.txt ]]; then
    cat ./howto.txt
else
    echo "Note: howto.txt file not found."
fi
