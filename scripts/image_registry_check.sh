#!/bin/bash

REPO=myownrepo.com/prefix
CP_IMAGES=images.txt

# Add repos
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add kubeshop https://kubeshop.github.io/helm-charts

# Build the dependencies
helm dependency build ../charts/testkube-enterprise

# Get images from the control plane chart
helm template test ../charts/testkube-enterprise --skip-crds --set global.imageRegistry=$REPO --set global.certificateProvider="" --set global.testWorkflows.createOfficialTemplates=false | grep "image:" | grep -v "{" | sed 's/"//g' | sed 's/docker.io\///g' | awk '{ print $2 }' | awk 'NF && !seen[$0]++' | sort > "$CP_IMAGES"

# Check for images that do not start with the image registry
failure=false
while IFS= read -r line; do
    if [[ ! "$line" =~ ^"$REPO" ]]; then
        echo "Failure: Line '$line' does not start with '$REPO'."
        failure=true
    fi
done < "$CP_IMAGES"

if [ "$failure" = true ]; then
    exit 1
fi

echo "All lines start with '$REPO'."
