#!/bin/bash
# build and remove dangling images in the system
docker build -t ghcr.io/netapp-polaris/neptune/astra/astra3dt:v0.1.0 .
docker rmi -f $(docker images -f "dangling=true" -q)