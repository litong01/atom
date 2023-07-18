#!/bin/bash
# build and remove dangling images in the system
docker build -t ghcr.io/litong01/astra/astra3dt:v0.1.0 .
docker rmi -f $(docker images -f "dangling=true" -q)