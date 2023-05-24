@echo off
docker run -it --rm --name astra --network host ^
   -e "SKIP_KUBE_CONTEXT_CHECK=true" ^
   -e "DEPLOY_TYPE=dev" ^
   -e "WORKDIR=/home/work/astra" ^
   -e "HOSTWORKDIR=%TEMP%/astra" ^
   -e "VAULT_ADDR=%VAULT_ADDR%" ^
   -e "GITHUB_USERNAME=%GITHUB_ID%" ^
   -e "GITHUB_TOKEN=%GITHUB_TOKEN%" ^
   -e "GITHUB_ID=%GITHUB_ID%" ^
   -e "DH_ID=%DH_ID%" ^
   -e "DH_TOKEN=%DH_TOKEN%" ^
   -e "CREDS_AUTH_CLIENT_ID=%CREDS_AUTH_CLIENT_ID%" ^
   -e "CREDS_AUTH_DOMAIN=%CREDS_AUTH_DOMAIN%" ^
   -e "CREDS_ISSUER_URL=%CREDS_ISSUER_URL%" ^
   -v /var/run/docker.sock:/var/run/docker.sock ^
   -v %TEMP%/astra:/home/work/astra ^
   -v %CD%:/home/polaris -v %USERPROFILE%/.kube:/home/.kube ^
   ghcr.io/netapp-polaris/polaris/astra/astradt:v0.1.0 time astra %*
