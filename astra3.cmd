REM The following environment variables can be set
REM    REGISTRY         - value should be registry include namespace such as docker.io/tli551/
REM    REGISTRY_USERID  - the user id to be used to login to the registry
REM    REGISTRY_TOEKN   - the token for the REGISTRY_USERID
REM    TAG              - the tag be used, default to latest
REM    PLATFORMS        - a list of image architectures to be built
REM All these variables are used when build and push images
@echo off
docker run -it --rm --name astra3 --network host ^
   -e "REGISTRY=%REGISTRY%" ^
   -e "REGISTRY_USERID=%REGISTRY_USERID%" ^
   -e "REGISTRY_TOKEN=%REGISTRY_TOKEN%" ^
   -e "TAG=%TAG%" ^
   -e "PLATFORMS=%PLATFORMS%" ^
   -v /var/run/docker.sock:/var/run/docker.sock ^
   -v %TEMP%/astra3:/home/work/astra3 ^
   -v %CD%:/home/neptune -v %USERPROFILE%/.kube:/home/.kube ^
   tli551/astra3dt:v0.1.0 time astra3 %*
