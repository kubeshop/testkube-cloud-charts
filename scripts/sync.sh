#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
update_script=$script_dir/update.sh

export enterprise_api_chart_version
export enterprise_ui_chart_version
export enterprise_worker_service_chart_version
export enterprise_ai_service_chart_version
export enterprise_api_app_version
export enterprise_ui_app_version
export enterprise_worker_service_app_version
export enterprise_ai_service_app_version

# Extract the version from the respective charts
enterprise_api_chart_version=$("$update_script" -c testkube-cloud-api --print-chart-version)
enterprise_ui_chart_version=$("$update_script" -c testkube-cloud-ui --print-chart-version)
enterprise_worker_service_chart_version=$("$update_script" -c testkube-worker-service --print-chart-version)
enterprise_ai_service_chart_version=$("$update_script" -c testkube-ai-service --print-chart-version)

# Extract the appVersion from the respective charts
enterprise_api_app_version=$("$update_script" -c testkube-cloud-api --print-app-version)
enterprise_ui_app_version=$("$update_script" -c testkube-cloud-ui --print-app-version)
enterprise_worker_service_app_version=$("$update_script" -c testkube-worker-service --print-app-version)
enterprise_ai_service_app_version=$("$update_script" -c testkube-ai-service --print-app-version)

# Update the values.yaml in the enterprise chart
echo "Updating testkube-cloud-api version in testkube-enterprise Helm chart to $enterprise_api_app_version"
yq eval -i '.testkube-cloud-api.image.tag = env(enterprise_api_app_version)' "charts/testkube-enterprise/values.yaml"
echo "Updating testkube-migrations version in testkube-enterprise Helm chart to $enterprise_api_app_version"
yq eval -i '.testkube-cloud-api.migrationImage.tag = env(enterprise_api_app_version)' "charts/testkube-enterprise/values.yaml"
echo "Updating testkube-cloud-api version in testkube-enterprise Helm chart for local-install values file to $enterprise_api_app_version"
yq eval -i '.testkube-cloud-api.image.tag = env(enterprise_api_app_version)' "charts/testkube-enterprise/local-values.yaml"
echo "Updating testkube-cloud-ui version in testkube-enterprise Helm chart to $enterprise_ui_app_version"
yq eval -i '.testkube-cloud-ui.image.tag = env(enterprise_ui_app_version)' "charts/testkube-enterprise/values.yaml"
echo "Updating testkube-cloud-ui version in testkube-enterprise Helm chart for local-install values file to $enterprise_ui_app_version"
yq eval -i '.testkube-cloud-ui.image.tag = env(enterprise_ui_app_version)' "charts/testkube-enterprise/local-values.yaml"
echo "Updating testkube-worker-service version in testkube-enterprise Helm chart to $enterprise_worker_service_app_version"
yq eval -i '.testkube-worker-service.image.tag = env(enterprise_worker_service_app_version)' "charts/testkube-enterprise/values.yaml"
echo "Updating testkube-worker-service version in testkube-enterprise Helm chart for local-install values file to to $enterprise_worker_service_app_version"
yq eval -i '.testkube-worker-service.image.tag = env(enterprise_worker_service_app_version)' "charts/testkube-enterprise/local-values.yaml"
echo "Updating testkube-cloud-api version in testkube-cloud-api values.yaml to $enterprise_api_app_version"
yq eval -i '.image.tag = env(enterprise_api_app_version)' "charts/testkube-cloud-api/values.yaml"
echo "Updating testkube-migrations version in testkube-cloud-api values.yaml to $enterprise_api_app_version"
yq eval -i '.migrationImage.tag = env(enterprise_api_app_version)' "charts/testkube-cloud-api/values.yaml"
echo "Updating testkube-cloud-ui version in testkube-cloud-ui values.yaml to $enterprise_ui_app_version"
yq eval -i '.image.tag = env(enterprise_ui_app_version)' "charts/testkube-cloud-ui/values.yaml"
echo "Updating testkube-worker-service version in testkube-worker-service values.yaml to $enterprise_worker_service_app_version"
yq eval -i '.image.tag = env(enterprise_worker_service_app_version)' "charts/testkube-worker-service/values.yaml"
echo "Updating testkube-ai-service version in testkube-ai-service values.yaml to $enterprise_ai_service_app_version"
yq eval -i '.image.tag = env(enterprise_ai_service_app_version)' "charts/testkube-ai-service/values.yaml"
echo "Updating testkube-ai-service version in testkube-enterprise Helm chart to $enterprise_ai_service_app_version"
yq eval -i '.testkube-ai-service.image.tag = env(enterprise_ai_service_app_version)' "charts/testkube-enterprise/values.yaml"


# Update the dependencies field in Chart.yaml
echo "Updating dependencies in Chart.yaml"
yq -i '.dependencies[] |= select(.name == "testkube-cloud-api") |= .version = env(enterprise_api_chart_version)' "charts/testkube-enterprise/Chart.yaml"
yq -i '.dependencies[] |= select(.name == "testkube-cloud-ui") |= .version = env(enterprise_ui_chart_version)' "charts/testkube-enterprise/Chart.yaml"
yq -i '.dependencies[] |= select(.name == "testkube-worker-service") |= .version = env(enterprise_worker_service_chart_version)' "charts/testkube-enterprise/Chart.yaml"
yq -i '.dependencies[] |= select(.name == "testkube-ai-service") |= .version = env(enterprise_ai_service_chart_version)' "charts/testkube-enterprise/Chart.yaml"

echo "Updating dependencies in testkube-enterprise Helm chart"
helm dependency update charts/testkube-enterprise

echo "Update completed successfully"
