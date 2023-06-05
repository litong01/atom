REM Sample script to setup environment variables for AC deployment
REM run myenv.cmd to setup environment variable
SET SKIP_KUBE_CONTEXT_CHECK=true
SET VAULT_ADDR="http://vault.openenglab.netapp.com"
SET GITHUB_TOKEN="Your github token"
SET GITHUB_ID="Your github ID"
SET GITHUB_USERNAME=${GITHUB_ID}
SET DEPLOY_TYPE=dev

SET CREDS_AUTH_CLIENT_ID="auth_client_id from vault"
SET CREDS_AUTH_DOMAIN=staging-netapp-cloud-account.auth0.com
SET CREDS_ISSUER_URL=https://staging-netapp-cloud-account.auth0.com/

SET IMAGE_HOST=kind-registry:5001
SET CLUSTER_ENDPOINT=integration.astra.netapp.io

REM Optional variables for very frequent docker hub access
SET DH_ID="Your docker hub id"
SET DH_TOKEN="your docker hub access token"