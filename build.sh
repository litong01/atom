#!/bin/bash
# build and remove dangling images in the system
docker build -t ghcr.io/netapp-polaris/polaris/astra/astradt:v0.1.0 .
docker rmi -f $(docker images -f "dangling=true" -q)