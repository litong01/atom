#!/bin/bash
# Sample script to setup environment variables for neptune
# When try to build image and publish images
#!/bin/bash
# Registry example values
# export REGISTRY=hub.docker.com/r/user123/
# export REGISTRY=ghcr.io/
export REGISTRY="your registry including namespace with trailing slash"
export REGISTRY_USERID="your image registry userid"
export REGISTRY_TOKEN="your image registry token"
export PLATFORMS=linux/arm64,linux/amd64
export TAG=latest