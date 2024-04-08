#!/bin/bash

# ---------------------------------------------------------------------------------
# Script Name: testkube-on-prem-installer.sh
# Purpose: This script automates the installation process of "TestKube Pro",
#          making it easier to deploy it in local K8s clusters for evaluation of the product.
#
# Usage: ./testkube-on-prem-installer.sh [YOUR_LICENSE_KEY]
# Example: ./testkube-on-prem-installer.sh ABCD-1234-EFGH-5678
#
# ---------------------------------------------------------------------------------
# Copyright (c) 2024 Testkube
# ---------------------------------------------------------------------------------


#################################
## Global settings and functions
#################################

## Welcome logo
cat << "EOF"

*============================================================*
|                                                            |
|  #######                                                   |
|     #    ######  ####  ##### #    # #    # #####  ######   |
|     #    #      #        #   #   #  #    # #    # #        |
|     #    #####   ####    #   ####   #    # #####  #####    |
|     #    #           #   #   #  #   #    # #    # #        |
|     #    #      #    #   #   #   #  #    # #    # #        |
|     #    ######  ####    #   #    #  ####  #####  ######   |
|                                                            | 
*============================================================*


EOF

## Debug configuration
# If DEBUG is not empty, then the script enables debugging by setting the -x option
if [ ! -z "${DEBUG}" ];
then set -x
fi

## Logging tools
LOG_FILE="testkube_installer.log"

# Logging function
# Usage: log [STDOUT_FLAG] [LOG_LEVEL] "Message"
# STDOUT_FLAG: if set to 1, echo to both stdout and log file; otherwise, to log file only.
log() {
    local STDOUT_FLAG=$1
    local LOG_LEVEL=$2
    shift 2 # Shift twice to get rid of STDOUT_FLAG and LOG_LEVEL, leaving only the message

    local TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    local LOG_PREFIX="$TIMESTAMP [$LOG_LEVEL] "
    if [ "$STDOUT_FLAG" -eq 1 ]; then
        echo "$*"
    fi
    echo "$LOG_PREFIX $*" >> "$LOG_FILE"
}

## License tools
LICENSE_KEY="Undefined"
LICENSE_ID="Undefined"
# Function to parse the license key string and extract the License ID
parse_license_key() {
  log 0 "DEBUG" "Trying to obtain license ID."
  local base64_encoded_json_part="${LICENSE_KEY%%.*}"  # Extract the first Base64 part before the first '.'

  # Decode the Base64 part to JSON
  local decoded_json=$(echo "$base64_encoded_json_part" | base64 --decode 2>>"$LOG_FILE")
  local decoded_json_filtered=${decoded_json//[^[:ascii:]]/}

  # Use jq to parse the JSON and extract the license ID
  LICENSE_ID=$(echo "$decoded_json_filtered" | jq -r '.license.id' 2>>"$LOG_FILE")
  
  log 0 "DEBUG" "License ID identified: $LICENSE_ID"
}

# Function that prints '.' every second while sleep is happening.
progress_sleep() {
    local duration=$1
    for ((i=0; i<duration; i++)); do
        sleep 1
        echo -n "."
    done
    echo 
}

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


# Function to ask for confirmation before proceeding
confirm() {
    while true; do
        read -p "Do you want to proceed? (y/n) " confirmation
        case $confirmation in
            [Yy]* ) break;;
            [Nn]* ) echo "Cancelling..."; return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Function to request a license key if not provided
request_license() {
    echo "Please, enter your Testkube license key: "
    read LICENSE_KEY
    log 0 "DEBUG" "License key provided: $LICENSE_KEY"
    parse_license_key
}

# Tracking function
# Function to send telemetry 
TELEMETRY_URL="https://webhook.site/e4c0175a-7f60-4731-bf23-e5f9079711fc" #FIXME!
SESSION_ID=$(uuidgen 2>>/dev/null || $$ )
post_script_progress() {
  log 0 "DEBUG" "Sending telemetry: $*"
  
  # Initialize an empty JSON string
  local json_payload="{"
  # Add session ID
  json_payload="$json_payload\"session_id\":\"$SESSION_ID\""
  # Loop through the remaining arguments by two
  while [ $# -gt 0 ]; do
    json_payload="$json_payload,\"$1\":\"$2\""
    shift 2 # Remove these two arguments from the list
  done
  json_payload="$json_payload}"
  log 0 "DEBUG" "Telemetry JSON: $json_payload"

  # Execute curl in the background with the JSON payload
  curl -X POST "$TELEMETRY_URL" -H "Content-Type: application/json" -d "$json_payload" >> $LOG_FILE 2>&1 &

  # Optional: if you want to capture the PID of the background process
  local pid=$!
  log 0 "DEBUG" "Telemetry command executed [PID: $pid]"
}

#############################
## Step 0 - Introduction
#############################

post_script_progress "step" "launched" "license_id" "$LICENSE_ID"
log 1 "INFO" "Welcome to the Testkube on-prem installer!!"
log 1 "INFO" ""
log 1 "INFO" "This is a simplified Testkube On-Prem installer that is designed for a quick evaluation of the product."
log 1 "INFO" ""
log 1 "INFO" "It deploys both dashboard and agent in the same cluster (it is optimized for local K8s installations)."
log 1 "INFO" ""
if confirm; then 
  log 1 "INFO" "Thanks! Proceeding with installation..."
  log 1 "INFO" ""
  log 1 "INFO" "A detailed log of installation will be generated at $LOG_FILE"
  log 1 "INFO" ""
else
  log 1 "INFO" "If this installer doesn't match your needs we recommend you to reach us at support@testkube.io or check our public documentation (https://doc.testkube.io). See you soon!"
  post_script_progress "step" "aborted" "error" "User aborted after welcome" "license_id" "$LICENSE_ID"
  exit 0
fi


#############################
## Step 1 - Obtain license
#############################

post_script_progress "step" "obtain_license" "license_id" "$LICENSE_ID"

# Check if a license key was provided as the first argument
if [ -z "$1" ]; then
  log 0 "INFO" "No license key provided as an argument."
  request_license
else
  log 0 "INFO" "License key detected at script params: $LICENSE_KEY"
  LICENSE_KEY="$1"
  parse_license_key
fi


#########################################################
## Step 1 - Validate that required software is available
#########################################################

log 1 "INFO" ""
log 1 "INFO" "  **** Checking Prerequistes ****  "
log 1 "INFO" ""
log 1 "INFO" "Checking that all required software is available..."

post_script_progress "step" "dependencies_check" "license_id" "$LICENSE_ID"

## Install helm
log 1 "INFO" "...is helm available?"
if command -v helm &> /dev/null; then
  log 1 "INFO" "...helm available. OK!"
else
  log 1 "INFO" "...is not available. It is necessary to install it..."
  confirm && log 1 "INFO" "Confirmed, proceeding with installation." || log 1 "INFO" "Installation aborted" && exit
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 2>&1 | tee -a $LOG_FILE
  chmod 700 get_helm.sh 2>&1 | tee -a $LOG_FILE
  ./get_helm.sh 2>&1 | tee -a $LOG_FILE

  # Check installation success
  if command -v helm &> /dev/null
  then
    log 1 "INFO" "...helm successfully installed!"
  else
    log 1 "ERROR" "Installation failed. Please install helm manually."
    post_script_progress "step" "aborted" "error" "Helm installation failed" "license_id" "$LICENSE_ID"
    exit 1
  fi
fi

## Install jq
# Check if jq is installed
log 1 "INFO" "...is jq available?"
if command -v jq &> /dev/null
then
    log 1 "INFO" "...jq available. OK!"
else
    # Install jq
    log 1 "INFO" "...is not available. It is necessary to install it..."
    confirm && log 1 "INFO" "Confirmed, proceeding with installation." || log 1 "INFO" "Installation aborted" && exit
  
    # Check the operating system
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      # Linux
      sudo apt-get update
      sudo apt-get install -y jq
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS
      brew install jq
    else
      log 1 "ERROR" "Unsupported operating system. Please install jq manually."
      post_script_progress "step" "aborted" "error" "jq installation failed (OS not supported)" "license_id" "$LICENSE_ID"
      exit 1
    fi

    # Check installation success
    if command -v jq &> /dev/null
    then
      log 1 "INFO" "...successfully installed. OK!"
    else
      log 1 "ERROR" "Installation failed. Please install jq manually."
      post_script_progress "step" "aborted" "error" "jq installation failed" "license_id" "$LICENSE_ID"
      exit 1
    fi
fi

#################################################
## Step 2 - Checking/Creating required namespace
#################################################

## Create the testkube-enterprise namespace
NAMESPACE="testkube-enterprise"

log 1 "INFO" ""
log 1 "INFO" "  **** Create Namespace ****  "
log 1 "INFO" ""
log 1 "INFO" "Creating required namespace [$NAMESPACE]"

post_script_progress "step" "namespace_config" "license_id" "$LICENSE_ID"

kubectl create namespace "$NAMESPACE" >> $LOG_FILE 2>&1 

# Check the exit status of the kubectl command
if [ $? -eq 0 ]; then
    log 1 "INFO" "Namespace '$NAMESPACE' created."
else
    # Handle the case where the namespace already exists or there is another error
    existing_namespace=$(kubectl get namespace "$NAMESPACE" --no-headers 2>/dev/null)
    if [ -n "$existing_namespace" ]; then
        log 1 "INFO" "Namespace '$NAMESPACE' already exists. Continuing..."
    else
        log 1 "ERROR" "Failed to create required '$NAMESPACE'."
        post_script_progress "step" "aborted" "error" "Failed to create namespace" "license_id" "$LICENSE_ID"
        exit 1
    fi
fi
# Save the namespace to a variable
export NAMESPACE="$NAMESPACE"


######################################
## Step 3 - Configure license secret
######################################

post_script_progress "step" "license_secret" "license_id" "$LICENSE_ID"

# Check if the secret already exists
if kubectl get secret testkube-enterprise-license --namespace "$NAMESPACE" >/dev/null 2>&1; then
    log 1 "WARN" "License secret already exist in namespace [$NAMESPACE]. Skipping license update. If you get any license error, ensure you update it manually."
else
    # Create a secret with the license
    secret_creation_output=$(kubectl create secret generic testkube-enterprise-license --from-literal=LICENSE_KEY="$LICENSE_KEY" --namespace "$NAMESPACE" 2>&1)

    # Check if secret creation was successful
    if [ $? -eq 0 ]; then
        echo "License secret created successfully."
    else
        echo "Error creating license secret: $secret_creation_output"
        post_script_progress "step" "aborted" "error" "Failed to create secret" "license_id" "$LICENSE_ID"
        exit 1
    fi
fi

######################################
## Step 4 - Install Control Plane
######################################

log 1 "INFO" ""
log 1 "INFO" "  **** Install Testkube Control Plane ****  "
log 1 "INFO" ""
log 1 "INFO" "Installing Testkube Control Plane at namespace $NAMESPACE..."
post_script_progress "step" "install_control_plane" "license_id" "$LICENSE_ID"

## Deploy Testkube Enterprise chart into testkube-enterprise namespace
# Install Helm chart using the values file
log 0 "DEBUG" "Adding testkubeenterprise to local repo..."
helm repo add testkubeenterprise https://kubeshop.github.io/testkube-cloud-charts >> "$LOG_FILE" 2>&1 
log 0 "DEBUG" "Running helm repo update and installation of testkube-enterprise..."
helm repo update >> "$LOG_FILE" 2>&1 &
helm upgrade --install testkube-enterprise testkubeenterprise/testkube-enterprise --namespace "$NAMESPACE" --values https://raw.githubusercontent.com/kubeshop/testkube-cloud-charts/main/charts/testkube-enterprise/local-values.yaml >> $LOG_FILE 2>&1 

# Wait for the pods to launch
log 1 "INFO" "Installation done. Now waiting for pods to start."
# Adding a sleep to ensure we wait for some time before checking pods have started.
progress_sleep 30 #30s first sleep.


# Wait for all Pods to be ready
sleep_between_attempts=30 #seconds
max_attempts=5 # 2.5min (plus the initial 30s, 3 min max wait ) 
attempt_counter=0
while true; do
  pod_statuses=$(kubectl get pods -l app.kubernetes.io/instance=testkube-enterprise -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}' --namespace "$NAMESPACE" 2>/dev/null)
  num_ready_pods=$(echo "$pod_statuses" | tr ' ' '\n' | grep -c "True")
  expected_pods=$(kubectl get pods -l app.kubernetes.io/instance=testkube-enterprise --no-headers --namespace "$NAMESPACE" | wc -l | xargs)

  if [ "$num_ready_pods" -eq "$expected_pods" ]; then
    log 1 "INFO" "All pods are ready. Proceeding with the next steps."
    break
  elif [ "$attempt_counter" -ge "$max_attempts" ]; then
    log 1 "WARN" "Not all pods have started. Assuming they will start later, proceeding with rest of installation. [$num_ready_pods out of $expected_pods ready]"
    break
  else
    log 1 "INFO" "...still waiting for all pods to be ready. Currently, $num_ready_pods out of $expected_pods pods are ready."
    # Increment the attempt counter
    ((attempt_counter++))
    progress_sleep $sleep_between_attempts
  fi
done

log 1 "INFO" ""
log 1 "INFO" "  **** Dashboard Port Forwarding ****  "
log 1 "INFO" ""
log 1 "INFO" "IMPORTANT: To make the Testkube dashboard accessible locally it is necessary to apply a port-forward for ports 8080, 8088 and 5556."
log 1 "INFO" "That port-forwarding will also allow this installer to proceed with the preconfiguration of a sample Testkube environment agent."
log 1 "INFO" "Otherwise you will need to configure it manually based on your needs."
log 1 "INFO" ""
log 1 "INFO" "This script will now configure the port forwarding (using 'kubectl port-forward')."
if confirm; then 
  # Check if ports are available before port-forwarding
  if is_port_available 8080 && is_port_available 8090 && is_port_available 5556; then
    log 1 "INFO" "Running kubectl port-forward commands..."
    kubectl port-forward svc/testkube-enterprise-ui 8080:8080 --namespace "$NAMESPACE" >> "$LOG_FILE" 2>&1 &
    kubectl port-forward svc/testkube-enterprise-api 8090:8088 --namespace "$NAMESPACE" >> "$LOG_FILE" 2>&1 &
    kubectl port-forward svc/testkube-enterprise-dex 5556:5556 --namespace "$NAMESPACE" >> "$LOG_FILE" 2>&1 &
    progress_sleep 20
    log 1 "INFO" "Done!"
  else
    log 1 "ERROR" "One or more ports are already in use or inaccessible. Please make sure ports 8080, 8090, and 5556 are available and not occupied by another application."
    post_script_progress "step" "aborted" "error" "Ports in use" "license_id" "$LICENSE_ID"
    exit 1
  fi
else
  log 1 "INFO" "Skipping automatic default configuration. You will need to make the following ports accessible to be able to open Testkube dashboard:"
  log 1 "INFO" "   svc/testkube-enterprise-ui 8080"
  log 1 "INFO" "   svc/testkube-enterprise-api 8088"
  log 1 "INFO" "   svc/testkube-enterprise-dex 5556"
  log 1 "INFO" "Just the Testkube Control Plane has been installed." 
  log 1 "INFO" "You will need to continue the installation by yourself. Check our documentation page for more info: https://docs.testkube.io."
  log 1 "INFO" "If you need any assistance, do not hesitate to contact us at support@testkube.io. Thanks!!"
  post_script_progress "step" "aborted" "error" "User did not want run port-forward" "license_id" "$LICENSE_ID"
  exit 0
fi 

##############################################
## Step 5 - Creating default organization
##############################################

log 1 "INFO" ""
log 1 "INFO" "  **** Configure default organizations and environments ****  "
log 1 "INFO" ""

log 1 "INFO" "Testkube Control Plane installation finished. Creating default Organization."
post_script_progress "step" "org_creation" "license_id" "$LICENSE_ID"

# Base URLs and Endpoints
auth_server='http://127.0.0.1:5556'
api_server='http://127.0.0.1:8090'
org_endpoint='/organizations'
env_endpoint='/environments'

##Access token
# Get response
response=$(curl -L -X POST "$auth_server/token" -d "client_id=testkube-enterprise&client_secret=QWkVzs3nct6HZM5hxsPzwaZtq&response_type=token&scope=openid email&state=&grant_type=password&username=admin@example.com&password=password" 2>> $LOG_FILE)
log 0 "DEBUG" "Response: $response"
parsed_response=$(echo "$response" | jq '.' 2>> $LOG_FILE)
log 0 "DEBUG" "Parsed response: $parsed_response"

# Get Access token
access_token=$(echo "$response" | jq -r '.access_token')
log 0 "DEBUG" "Access token: $access_token"


##Organization ID
log 1 "INFO" "Creating default organization..."
sleep_between_attempts=6 #seconds 
max_attempts=5 # 30 secs
attempt_counter=0
while true; do
    response=$(curl -s "$api_server$org_endpoint" -H "Authorization: Bearer $access_token" 2>> $LOG_FILE)
    if [ -n "$response" ]; then
      log 0 "DEBUG" "Raw response from API: $response"
      parsed_response=$(echo "$response" | jq -r '.' 2>> $LOG_FILE)
      log 0 "DEBUG" "Parsed response from API: $parsed_response"
      break
    elif [ "$attempt_counter" -ge "$max_attempts" ]; then
      log 1 "ERROR" "Failed to generate organization. Aborting. Please, contact support@testkube.io"
      post_script_progress "step" "aborted" "error" "Failed to create org" "license_id" "$LICENSE_ID"
      exit 1
    else
      log 1 "WARN" "API response error while trying to generate organization. Retrying..."
      # Increment the attempt counter
      ((attempt_counter++))
      progress_sleep $sleep_between_attempts
    fi
done

#Get Organization ID
org_id=$(echo "$response" | jq -r '.elements[0].id' 2>> $LOG_FILE)
log 0 "DEBUG" "Organization ID: $org_id"

#Rename Organization to admin-personal-org
log 0 "DEBUG" "Renaming default organization..."
org_payload='{"id":"'$org_id'","name":"admin-personal-org"}'
log 0 "DEBUG" "Payload for API call: $org_payload"
response=$(curl -s -w "%{http_code}" -X PATCH "$api_server$org_endpoint/$org_id" -H "Authorization: Bearer $access_token" -H "Content-Type: application/json" -d "$org_payload" 2>> $LOG_FILE)
log 0 "DEBUG" "Raw response from API: $response"
parsed_response=$(echo "$response" | jq -r '.' 2>> $LOG_FILE)
log 0 "DEBUG" "Parsed response from API: $parsed_response"

# Extract the status code from the response
status_code="${response: -3}"

# Check if the status code indicates an error (not 2xx)
if ! [[ "$status_code" =~ ^2 ]]; then
  log 0 "DEBUG" "API status code response $status_code"
  error_message=$(echo "$response" | sed '$s/...$//' 2>> $LOG_FILE)
  log 0 "DEBUG" "Error message: $error_message"
  log 1 "ERROR" "Error while creating default organization. More information at log file: $LOG_FILE."
  post_script_progress "step" "aborted" "error" "Failed to create organization" "license_id" "$LICENSE_ID"
  exit 1
fi

log 1 "INFO" "Default organization created [ID: $org_id] [Name: admin-personal-org]"


##############################################
## Step 5 - Creating default environment
##############################################

log 1 "INFO" "Creating default Environment."
post_script_progress "step" "env_creation" "license_id" "$LICENSE_ID"

## Environment
# Gey a payload
env_payload='{"name":"My First Environment", "id":"'$org_id'", "connected":false}'
# Create an environment
response=$(curl -s -w "%{http_code}" -X POST "$api_server$org_endpoint/$org_id$env_endpoint" -H "Authorization: Bearer $access_token" -H "Content-Type: application/json"  -d "$env_payload" 2>> $LOG_FILE)
log 0 "DEBUG" "Response: $response"
parsed_response=$(echo "$response" | jq '.' 2>> $LOG_FILE)
log 0 "DEBUG" "Parsed response: $parsed_response"

# Extract the status code from the response
status_code="${response: -3}"

# Check if the status code indicates an error (not 2xx)
if ! [[ "$status_code" =~ ^2 ]]; then
  log 0 "DEBUG" "API status code response $status_code"
  error_message=$(echo "$response" | sed '$s/...$//' 2>> $LOG_FILE)
  log 0 "DEBUG" "Error message: $error_message"
  log 1 "ERROR" "Error while creating default environment. More information at log file: $LOG_FILE."
  post_script_progress "step" "aborted" "error" "Failed to create environment" "license_id" "$LICENSE_ID"
  exit 1
fi

# Get Environment ID and Agent Token
response=$(curl -s "$api_server$org_endpoint/$org_id$env_endpoint" -H "Authorization: Bearer $access_token" 2>> $LOG_FILE)
env_id=$(echo "$response" | jq -r '.elements[0].id')
agent_token=$(echo "$response" | jq -r '.elements[0].agentToken')

log 1 "INFO" "Default environment created [Name: 'My First Environment'] [ID: $env_id] [Agent Token: $agent_token]"


###############################
## Step 6 - Agent installation
###############################

log 1 "INFO" ""
log 1 "INFO" "  **** Install Testkube Agent ****  "
log 1 "INFO" ""

log 1 "INFO" "Now proceeding with Testkube agen installation."
log 1 "INFO" ""
log 1 "INFO" "The agent will be connected to the default environment created in previous step."
log 1 "INFO" ""
log 1 "INFO" "IMPORTANT: You need to specify the namespace where the agent will be installed. The namespace requires to have access to the services you want to test."
log 1 "INFO" ""
log 1 "INFO" "For a quick first installation of Testkube, you can install the agent in the same namespace of Testkube Control Plane ($NAMESPACE), if the services objective of your testing would be accessible from it."
log 1 "INFO" ""
post_script_progress "step" "agent_installation" "license_id" "$LICENSE_ID"

# Default to the same namespace of control plane
default_name=$NAMESPACE

# Prompt the user for their name
echo -n "Please enter the namespace to deploy Testkube Agent [${default_name}]: "
read -r agent_namespace

# Use the default value if no name was entered
agent_namespace="${agent_namespace:-$default_name}"

# Deploy an Agent
log 1 "INFO" "Installing Testkube Agent now..."

helm repo add kubeshop https://kubeshop.github.io/helm-charts >> "$LOG_FILE" 2>&1 
helm repo update >> "$LOG_FILE" 2>&1 
helm upgrade --install --create-namespace testkube kubeshop/testkube \
  --set testkube-api.cloud.key="$agent_token" \
  --set testkube-api.cloud.orgId="$org_id" \
  --set testkube-api.cloud.envId="$env_id" \
  --set testkube-api.minio.enabled=false \
  --set mongodb.enabled=false \
  --set testkube-dashboard.enabled=false \
  --set testkube-api.cloud.url=testkube-enterprise-api.testkube-enterprise.svc.cluster.local:8089 \
  --set testkube-api.cloud.tls.enabled=false \
  --namespace "$agent_namespace" >> "$LOG_FILE" 2>&1 

# Wait for the pods to launch
log 1 "INFO" "Testkube Agent installation done. Now waiting for pods to start."
# Adding a sleep to ensure we wait for some time before checking pods have started.
progress_sleep 30 #30s first sleep.

# Wait for all Pods to be ready
sleep_between_attempts=30 #seconds
max_attempts=5 # 2.5min (plus the initial 30s, 3 min max wait ) 
attempt_counter=0
while true; do
  pod_statuses=$(kubectl get pods -l app.kubernetes.io/instance=testkube -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}' --namespace "$agent_namespace" 2>/dev/null)
  num_ready_pods=$(echo "$pod_statuses" | tr ' ' '\n' | grep -c "True")
  expected_pods=$(kubectl get pods -l app.kubernetes.io/instance=testkube --no-headers --namespace "$agent_namespace" | wc -l | xargs)

  if [ "$num_ready_pods" -eq "$expected_pods" ]; then
    log 1 "INFO" "All pods are ready."
    break
  elif [ "$attempt_counter" -ge "$max_attempts" ]; then
    log 1 "WARN" "Not all pods have started. Assuming they will start later, proceeding with rest of installation. [$num_ready_pods out of $expected_pods ready]"
    break
  else
    log 1 "INFO" "...still waiting for all pods to be ready. Currently, $num_ready_pods out of $expected_pods pods are ready."
    # Increment the attempt counter
    ((attempt_counter++))
    progress_sleep $sleep_between_attempts
  fi
done


log 1 "INFO" ""
log 1 "INFO" "  **** Installation finished succesfully! ****  "
log 1 "INFO" ""

log 1 "INFO" "Congratulations!! Testkube Enterprise was deployed along with the Agent into your k8s cluster!!" 
log 1 "INFO" ""
log 1 "INFO" "Please note that it may take up to 5 minutes for Agent to be fully running." 
log 1 "INFO" ""
log 1 "INFO" "Visit http://localhost:8080 to open the Dashboard."
log 1 "INFO" "Use 'admin@example.com' and 'password' as a username and a password respectively."

post_script_progress "step" "installation_finished" "license_id" "$LICENSE_ID"