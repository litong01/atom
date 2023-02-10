#!/bin/bash
# Sample script to setup environment variables for ACS deployment
# Run source myenv.sh to setup environment variable
export SKIP_KUBE_CONTEXT_CHECK=true
export VAULT_ADDR="http://vault.openenglab.netapp.com"
export GITHUB_USERNAME="Your full name"
export GITHUB_TOKEN="Your github token"
export GITHUB_ID="Your github ID"
export DEPLOY_TYPE=dev

# export VAULT_ADDR="http://vault.openenglab.netapp.com"
# vault login -method=github token=${GITHUB_TOKEN}
# vault kv get astra/cloud-account/${DEPLOY_TYPE} # DEPLOY_TYPE being dev | prod (default is dev)
# the above command will output some values, the value of auth_client_id should give
# you the value for CREDS_AUTH_CLIENT_ID

export CREDS_AUTH_CLIENT_ID="auth_client_id from vault"
export CREDS_AUTH_DOMAIN=staging-netapp-cloud-account.auth0.com
export CREDS_ISSUER_URL=https://staging-netapp-cloud-account.auth0.com/

# vault kv get astra/image/cicd
# The above command will output image_username and image_password, these two
# values should be used for CREDS_IMAGE_USERNAME and CREDS_IMAGE_PASSWORD
export CREDS_IMAGE_USERNAME="Your image repo username from vault kv"
export CREDS_IMAGE_PASSWORD="Your image repo password from vault kv"

# Assume that your auth2.json is in ${HOME}/work directory
export PCLOUD_AUTH2=${HOME}/work/auth2.json
