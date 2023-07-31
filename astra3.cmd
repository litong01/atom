@echo off
docker run -it --rm --name astra3 --network host ^
   -v /var/run/docker.sock:/var/run/docker.sock ^
   -v %TEMP%/astra3:/home/work/astra3 ^
   -v %CD%:/home/neptune -v %USERPROFILE%/.kube:/home/.kube ^
   tli551/astra3dt:v0.1.0 time astra3 %*
