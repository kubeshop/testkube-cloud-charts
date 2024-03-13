#!/bin/bash
echo "Installing Testkube Enterprise..."

# If DEBUG is not empty, then the script enables debugging by setting the -x option
if [ ! -z "${DEBUG}" ];
then set -x
fi

## Install helm
echo "Checking for helm installation.."
if command -v helm &> /dev/null; then
    echo "Helm is already installed."
else
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
  chmod 700 get_helm.sh \
  ./get_helm.sh
fi

## Install jq
# Check if jq is installed
if command -v jq &> /dev/null
then
    echo "jq is already installed."
else
    # Install jq
    echo "jq is not installed. Installing now..."

    # Check the operating system
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        sudo apt-get update
        sudo apt-get install -y jq
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install jq
    else
        echo "Unsupported operating system. Please install jq manually."
        exit 1
    fi

    # Check installation success
    if command -v jq &> /dev/null
    then
        echo "jq has been successfully installed."
    else
        echo "Installation failed. Please install jq manually."
        exit 1
    fi
fi

## Create the testkube-enterprise namespace
NAMESPACE="testkube-enterprise"

kubectl create namespace "$NAMESPACE" 2>/dev/null

# Check the exit status of the kubectl command
if [ $? -eq 0 ]; then
    echo "Namespace '$NAMESPACE' created."
else
    # Handle the case where the namespace already exists or there is another error
    existing_namespace=$(kubectl get namespace "$NAMESPACE" --no-headers 2>/dev/null)
    if [ -n "$existing_namespace" ]; then
        echo "Namespace '$NAMESPACE' already exists. Continuing..."
    else
        echo "Error: Failed to create namespace '$NAMESPACE'."
        exit 1
    fi
fi
# Save the namespace to a variable
export NAMESPACE="$NAMESPACE"

## License

# Check if the secret already exists
if kubectl get secret testkube-enterprise-license --namespace "$NAMESPACE" >/dev/null 2>&1; then
    echo "Secret already exists. Continuing..."
else
    # Ask the user for the license key value
    read -p "Please enter the value for the license key from the email: " license_value

    # Create a secret with the license
    secret_creation_output=$(kubectl create secret generic testkube-enterprise-license --from-literal=LICENSE_KEY="$license_value" --namespace "$NAMESPACE" 2>&1)

    # Check if secret creation was successful
    if [ $? -eq 0 ]; then
        echo "Secret created successfully."
    else
        echo "Error creating secret: $secret_creation_output"
        exit 1
    fi
fi

# Insert a namespace to deploy an Agent
read -p "Please enter the namespace to deploy Testkube Agent: " agent_namespace

## Deploy Testkube Enterprise chart into testkube-enterprise namespace
# Install Helm chart using the values file
helm repo add testkubeenterprise https://kubeshop.github.io/testkube-cloud-charts
echo "Installing testkube-enterprise helm chart into your k8s cluster."
helm repo update && helm upgrade --install testkube-enterprise testkubeenterprise/testkube-enterprise --namespace "$NAMESPACE" --values https://raw.githubusercontent.com/kubeshop/testkube-cloud-charts/develop/charts/testkube-enterprise/local-values.yaml

# Wait for the pods to launch
sleep 40

# Function to check if a port is available
function is_port_available() {
  local port=$1
  local result=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$port)

  # Check if the HTTP status code is not 200 (OK)
  if [ "$result" -ne 200 ]; then
    return 0  # Port is available
  else
    return 1  # Port is not available
  fi
}


# Wait for all Pods to be ready
while true; do
  pod_statuses=$(kubectl get pods -l app.kubernetes.io/instance=testkube-enterprise -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}' --namespace "$NAMESPACE" 2>/dev/null)
  num_ready_pods=$(echo "$pod_statuses" | tr ' ' '\n' | grep -c "True")

  if [ "$num_ready_pods" -eq "$(kubectl get pods -l app.kubernetes.io/instance=testkube-enterprise --no-headers --namespace "$NAMESPACE" | wc -l)" ]; then
    echo "All pods are ready. Proceeding with the next steps."

    # Check if ports are available before port-forwarding
    if is_port_available 8080 && is_port_available 8090 && is_port_available 5556; then

      kubectl port-forward svc/testkube-enterprise-ui 8080:8080 --namespace "$NAMESPACE" &
      kubectl port-forward svc/testkube-enterprise-api 8090:8088 --namespace "$NAMESPACE" &
      kubectl port-forward svc/testkube-enterprise-dex 5556:5556 --namespace "$NAMESPACE" &
      sleep 20
      break
    else
      echo "Error: One or more ports are already in use or inaccessible. Please make sure ports 8080, 8090, and 5556 are available and not occupied by another application."
      exit 1
    fi

  else
    echo "Waiting for all pods to be ready. Currently, $num_ready_pods out of $(kubectl get pods -l app.kubernetes.io/instance=testkube-enterprise --no-headers --namespace "$NAMESPACE" | wc -l) pods are ready."
    sleep 2
  fi
done

##Access token
# Get response
response=$(curl -L -X POST 'http://127.0.0.1:5556/token' -d "client_id=testkube-enterprise&client_secret=QWkVzs3nct6HZM5hxsPzwaZtq&response_type=token&scope=openid email&state=&grant_type=password&username=admin@example.com&password=password")
echo "Response:"
echo "$response" | jq '.'

# Get Access token
access_token=$(echo "$response" | jq -r '.access_token')
echo "Access token: $access_token"

# Base URLs and Endpoints
auth_server='http://127.0.0.1:5556'
api_server='http://127.0.0.1:8090'
org_endpoint='/organizations'
env_endpoint='/environments'

##Organization ID
#Get response
while true; do
    response=$(curl -s "$api_server$org_endpoint" -H "Authorization: Bearer $access_token")
    if [ -n "$response" ]; then
        echo "Response from API:"
        echo "$response" | jq '.'
        break
    else
        echo "Error retrieving response. Retrying..."
        sleep 2
    fi
done

#Get Organization ID
org_id=$(echo "$response" | jq -r '.elements[0].id')
echo "Organization ID: $org_id"

#Rename Organization to admin-personal-org
org_payload='{"id":"'$org_id'","name":"admin-personal-org"}'
response=$(curl -s -w "%{http_code}" -X PATCH "$api_server$org_endpoint/$org_id" -H "Authorization: Bearer $access_token" -H "Content-Type: application/json" -d "$org_payload")

# Extract the status code from the response
status_code="${response: -3}"

# Check if the status code indicates an error (not 2xx)
if ! [[ "$status_code" =~ ^2 ]]; then
    echo "Request failed with status code: $status_code"

    error_message=$(echo "$response" | sed '$s/...$//')
    echo "Error message: $error_message"
    exit 1
fi

# Continue with the rest of your script...
echo "Request to rename an Organization was successful. Continuing with the script..."


## Environment
# Gey a payload
env_payload='{"name":"My First Environment", "id":"'$org_id'", "connected":false}'
# Create an environment
curl -X POST "$api_server$org_endpoint/$org_id$env_endpoint" \
  -H "Authorization: Bearer $access_token" \
  -H "Content-Type: application/json" \
  -d "$env_payload"

# Get Environment ID and Agent Token
response=$(curl -s "$api_server$org_endpoint/$org_id$env_endpoint" -H "Authorization: Bearer $access_token")
env_id=$(echo "$response" | jq -r '.elements[0].id')
agent_token=$(echo "$response" | jq -r '.elements[0].agentToken')

# Deploy an Agent
helm repo add kubeshop https://kubeshop.github.io/helm-charts
helm repo update && helm upgrade --install --create-namespace testkube kubeshop/testkube \
  --set testkube-api.cloud.key="$agent_token" \
  --set testkube-api.cloud.orgId="$org_id" \
  --set testkube-api.cloud.envId="$env_id" \
  --set testkube-api.minio.enabled=false \
  --set mongodb.enabled=false \
  --set testkube-dashboard.enabled=false \
  --set testkube-api.cloud.url=testkube-enterprise-api.testkube-enterprise.svc.cluster.local:8089 \
  --set testkube-api.cloud.tls.enabled=false \
  --namespace "$agent_namespace"

# Sleep
sleep 50

# Wait for all Pods to be ready
while true; do
  pod_statuses=$(kubectl get pods -l app.kubernetes.io/instance=testkube -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}' --namespace "$agent_namespace" 2>/dev/null)
  num_ready_pods=$(echo "$pod_statuses" | tr ' ' '\n' | grep -c "True")

  if [ "$num_ready_pods" -eq "$(kubectl get pods -l app.kubernetes.io/instance=testkube --no-headers --namespace "$agent_namespace" | wc -l)" ]; then
    echo "All pods are ready"
    break
  else
    echo "Waiting for all pods to be ready. Currently, $num_ready_pods out of $(kubectl get pods -l app.kubernetes.io/instance=testkube --no-headers --namespace "$agent_namespace" | wc -l) pods are ready."
    sleep 2
  fi
done


echo "Testkube Enterprise was deployed along with the Agent into your k8s cluster. Please note that it may take up to 5 minutes for Agent to be fully running. Visit http://localhost:8080 to open the Dashboard. Use 'admin@example.com' and 'password' as a username and a password respectively."
