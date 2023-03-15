#!/bin/bash
# Sample script to setup environment variables for ACS deployment
# Run source myenv.sh to setup environment variable
export SKIP_KUBE_CONTEXT_CHECK=true
export VAULT_ADDR="http://vault.openenglab.netapp.com"
export GITHUB_TOKEN="Your github token"
export GITHUB_ID="Your github ID"
export DEPLOY_TYPE=dev

export CREDS_AUTH_CLIENT_ID="auth_client_id from vault"
export CREDS_AUTH_DOMAIN=staging-netapp-cloud-account.auth0.com
export CREDS_ISSUER_URL=https://staging-netapp-cloud-account.auth0.com/

export CREDS_IMAGE_USERNAME="Your image repo username from vault kv"
export CREDS_IMAGE_PASSWORD="Your image repo password from vault kv"

export IMAGE_HOST=localhost:5001
export CLUSTER_ENDPOINT=integration.astra.netapp.io

# Optional variables for very frequent docker hub access
export DH_ID="Your docker hub id"
export DH_TOKEN="your docker hub access token"