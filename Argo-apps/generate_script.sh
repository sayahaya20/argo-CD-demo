#!/bin/bash

# Function to create a Kubernetes Secret manifest
create_secret_manifest() {
    cat <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: $1
type: Opaque
data:
EOF
    while IFS= read -r line; do
        key=$(echo "$line" | cut -d= -f1)
        value=$(echo "$line" | cut -d= -f2-)
        if [ -n "$key" ] && [ -n "$value" ]; then
            encoded_value=$(echo -n "$value" | base64)
            echo "  $key: $encoded_value"
        fi
    done < "$2"
}

# Function to seal the Kubernetes Secret manifest using kubeseal
seal_secret_manifest() {
    kubeseal --controller-namespace argocd --controller-name sealed-secrets
}

# Generate a random filename for the sealed secret manifest
random_file=$(mktemp -u sealed_secret_XXXXXXXX.yaml)

# Parse command line arguments
if [ $# -eq 0 ]; then
    echo "Usage: $0 [KEY1=VALUE1 [KEY2=VALUE2 ...]] | --file <env_file>"
    exit 1
elif [ "$1" = "--file" ]; then
    if [ $# -ne 2 ]; then
        echo "Usage: $0 [KEY1=VALUE1 [KEY2=VALUE2 ...]] | --file <env_file>"
        exit 1
    fi
    create_secret_manifest "my-secret" "$2" | seal_secret_manifest > "$random_file"
else
    create_secret_manifest "my-secret" <(echo "$@") | seal_secret_manifest > "$random_file"
fi

# Remove the brackets and quotes from the saved file
sed -i 's/{//g; s/}//g; s/"//g; s/,//g' "$random_file"

# Output the random filename
echo "Sealed secret manifest saved to: $random_file"

# Output the content of the file
cat "$random_file"