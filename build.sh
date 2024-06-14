#!/bin/bash
# build and remove dangling images in the system
docker build -t tli551/atom:v0.1.0 .
docker rmi -f $(docker images -f "dangling=true" -q)