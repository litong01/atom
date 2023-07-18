@echo off
docker run -it --rm --name astra3 --network host ^
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
   -v /var/run/docker.sock:/var/run/docker.sock ^
   -v %TEMP%/astra3:/home/work/astra3 ^
   -v %CD%:/home/neptune -v %USERPROFILE%/.kube:/home/.kube ^
   ghcr.io/netapp-polaris/neptune/astra/astra3dt:v0.1.0 time astra3 %*
