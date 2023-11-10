#!/bin/bash

generate_access_key_id() {
    echo "$(tr -dc 'A-Z0-9' < /dev/urandom | head -c 20)"
}

generate_secret_access_key() {
    echo "$(tr -dc 'A-Za-z0-9+/' < /dev/urandom | head -c 40)"
}

mock_access_key_id=$(generate_access_key_id)
mock_secret_access_key=$(generate_secret_access_key)

echo "Mock AWS Access Key ID: $mock_access_key_id"
echo "Mock AWS Secret Access Key: $mock_secret_access_key"
