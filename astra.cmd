@echo off
docker run --rm --name astra --network host ^
   -e "SKIP_KUBE_CONTEXT_CHECK=true" ^
   -e "DEPLOY_TYPE=dev" ^
   -e "WORKDIR=/home/work/astra" ^
   -e "HOSTWORKDIR=%TEMP%/astra" ^
   -e "VAULT_ADDR=%VAULT_ADDR%" ^
   -e "GITHUB_USERNAME=%GITHUB_USERNAME%" ^
   -e "GITHUB_TOKEN=%GITHUB_TOKEN%" ^
   -e "GITHUB_ID=%GITHUB_ID%" ^
   -e "CREDS_AUTH_CLIENT_ID=%CREDS_AUTH_CLIENT_ID%" ^
   -e "CREDS_AUTH_DOMAIN=%CREDS_AUTH_DOMAIN%" ^
   -e "CREDS_ISSUER_URL=%CREDS_ISSUER_URL%" ^
   -e "CREDS_IMAGE_USERNAME=%CREDS_IMAGE_USERNAME%" ^
   -e "CREDS_IMAGE_PASSWORD=%CREDS_IMAGE_PASSWORD%" ^
   -v /var/run/docker.sock:/var/run/docker.sock ^
   -v %TEMP%/astra:/home/work/astra ^
   -v %CD%:/home/polaris -v %USERPROFILE%/.kube:/home/.kube ^
   ghrc.io/netapp-polaris/polaris/astra/astradt:v0.1.0 astra %*
