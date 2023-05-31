#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
update_script=$script_dir/update.sh

export enterprise_api_version
export enterprise_ui_version

# Extract the appVersion from the respective charts
enterprise_api_version=$("$update_script" -c testkube-cloud-api --print-app-version)
enterprise_ui_version=$("$update_script" -c testkube-cloud-ui --print-app-version)

# Update the values.yaml in the enterprise chart
echo "Updating testkube-cloud-api version in testkube-enterprise Helm chart to $enterprise_api_version"
yq eval -i '.testkube-cloud-api.image.tag = env(enterprise_api_version)' "charts/testkube-enterprise/values.yaml"
echo "Updating testkube-cloud-ui version in testkube-enterprise Helm chart to $enterprise_ui_version"
yq eval -i '.testkube-cloud-ui.image.tag = env(enterprise_ui_version)' "charts/testkube-enterprise/values.yaml"

# Update the dependencies field in Chart.yaml
echo "Updating dependencies in Chart.yaml"
yq -i '.dependencies[] |= select(.name == "testkube-cloud-api") |= .version = env(enterprise_api_version)' "charts/testkube-enterprise/Chart.yaml"
yq -i '.dependencies[] |= select(.name == "testkube-cloud-ui") |= .version = env(enterprise_ui_version)' "charts/testkube-enterprise/Chart.yaml"

echo "Update completed successfully"
