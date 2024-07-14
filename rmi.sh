#!/bin/bash
# Define some colors
ColorOff='\033[0m'        # Text Reset
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green

# Set your project ID and image prefix
IMAGENAMES=("swift-networking-controller" "ntapvol-snat-controller" "quark-operator" \
            "node-monitor" "netapp-ha-controller" "podrick" "nodevol-controller" \
            "netapp-volume-controller" "nodevol-worker" "cloud-snapshot-controller")
PROJECT_ID="netapp-hcl"
TAG_PREFIX="${USER}-"

for IMAGENAME in ${IMAGENAMES[@]}; do
  # List all tags for the specified image and filter by the tag prefix
  # echo -e "Looking for image ${Green}$IMAGENAME${ColorOff} with tag prefix: ${Green}$TAG_PREFIX${ColorOff}"
  IMAGETAGS=$(gcloud container images list-tags us.gcr.io/$PROJECT_ID/$IMAGENAME --format="get(TAGS)" | grep "^$TAG_PREFIX")
  if [ -z "$IMAGETAGS" ]; then
    echo -e "No ${Green}us.gcr.io/${PROJECT_ID}/$IMAGENAME${ColorOff} image found with tag prefix: ${Green}$TAG_PREFIX${ColorOff}"
    continue
  fi
  # Loop through each image and delete it
  for IMAGETAG in $IMAGETAGS; do
    # Redirect the warning message to /dev/null.
    echo "Deleting image: us.gcr.io/${PROJECT_ID}/${IMAGENAME}:$IMAGETAG"
    gcloud container images delete "us.gcr.io/${PROJECT_ID}/${IMAGENAME}:$IMAGETAG" --force-delete-tags --quiet 2>/dev/null
    # Alternative way to delete the image using sha256 digest
    # Getting the sha256 digest of the image
    # IMAGESHA256=$(gcloud container images describe "us.gcr.io/${PROJECT_ID}/${IMAGENAME}:$IMAGETAG" --format="get(digest,tags)" 2>/dev/null)
    # gcloud container images delete "us.gcr.io/${PROJECT_ID}/${IMAGENAME}:$IMAGESHA256" --force-delete-tags --quiet 2>/dev/null
  done
done
