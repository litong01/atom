REM Sample script to setup environment variables for Neptune deployment
REM When try to build image and publish images
SET REGISTRY="your registry including namespace with trailing slash"
SET REGISTRY_USERID="your image registry userid"
SET REGISTRY_TOKEN="your image registry token"
SET PLATFORMS=linux/arm64,linux/amd64
SET TAG=latest