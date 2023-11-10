#!/bin/bash

generate_access_key_id() {
    # AWS Access Key IDs are 20 characters long with uppercase alpha-numeric characters
    echo "$(tr -dc 'A-Z0-9' < /dev/urandom | head -c 20)"
}

generate_secret_access_key() {
    # AWS Secret Access Keys are 40 characters long with base64 characters
    echo "$(tr -dc 'A-Za-z0-9+/' < /dev/urandom | head -c 40)"
}

mock_access_key_id=$(generate_access_key_id)
mock_secret_access_key=$(generate_secret_access_key)

echo "Mock AWS Access Key ID: $mock_access_key_id"
echo "Mock AWS Secret Access Key: $mock_secret_access_key"
