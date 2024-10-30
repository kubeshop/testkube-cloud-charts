#!/bin/bash

CP_IMAGES=images.txt

# Add repos
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add kubeshop https://kubeshop.github.io/helm-charts

# Build the dependencies
helm dependency build ../charts/testkube-enterprise

# Get images from the control plane chart
helm template test ../charts/testkube-enterprise --skip-crds --set global.certificateProvider="" --set global.testWorkflows.createOfficialTemplates=false | grep "image:" | grep -v "{" | sed 's/"//g' | sed 's/docker.io\///g' | awk '{ print $2 }' | awk 'NF && !seen[$0]++' | sort > "$CP_IMAGES"

# Check for images that do not start with the image registry
failure=false
while IFS= read -r image; do

    docker scout cves $image --platform linux/amd64 --exit-code --only-severity critical -o /tmp/scout.log
    ec=$?

    if [ $ec -ne 0 ]; then
        echo "Failure: The '$image' has critical CVEs."
        echo "*******************"
        echo "DOCKER SCOUT OUTPUT"
        echo "==================="
        cat /tmp/scout.log
        echo "==================="
        failure=true
    fi
done < "$CP_IMAGES"

if [ "$failure" = true ]; then
    echo "Critical CVEs detected."
    exit 1
fi

echo "No critical CVEs detected."
