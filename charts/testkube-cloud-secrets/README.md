# Helm Chart: testkube-cloud-secrets

This Helm chart deploys the testkube-cloud-secrets and utilizes Google Cloud Secret Manager to manage API secrets.

## Prerequisites

- Kubernetes cluster is set up and Helm is installed.
- You have access to Google Cloud Platform (GCP) and have the necessary credentials to interact with Secret Manager.
- You have created the required API secrets in GCP Secret Manager.

## Installation

1. Clone the repository and navigate to the helm chart directory:

```
git clone git@github.com:kubeshop/testkube-cloud-charts.git
cd testkube-cloud-charts
```

Update the values.yaml file with your specific configuration.
Under the apiSecrets section or uiSecrets, list the keys as the environment variables you want to inject into the container.
Set the corresponding values as the GCP Secret Manager key paths for each secret.
Example values.yaml:

```
apiSecrets:
  API_KEY: gcp_secret_api_key
  DB_PASSWORD: gcp_secret_db_password
```

Install the Helm chart with your custom values:

```
helm install api-secrets ./ --values values.yaml
```

as soon as the external secrets installs in your environment you can reference to the secret keys via your deployment config like below:

```
env:
- name: API_KEY
  valueFrom:
    secretKeyRef:
      name: api-external-secrets
      key: API_KEY
```

if you need to reference to the keys for ui secrets just change `api-external-secrets` to `ui-external-secrets`
