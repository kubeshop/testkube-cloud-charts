# Testkube Enterprise Helm Chart Installation and Usage Guide

This guide provides step-by-step instructions for installing and using Testkube Enterprise Helm chart.
Testkube Enterprise is a Kubernetes-native testing platform that offers enterprise features for efficient testing and quality assurance processes.

## Prerequisites

Before you begin, ensure that you have the following prerequisites:
* Kubernetes cluster (version 1.21+)
* [Helm](https://helm.sh/docs/intro/quickstart/) (version 3+)
* [cert-manager](https://cert-manager.io/docs/installation/) (version 1.11+)
* [NGINX Controller](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/) (version v1.8+)
* Access to a domain for creating Ingress rules
* License key

## Configuration

### Docker images
First, make sure you have access to the Testkube Enterprise API & Dashboard Docker images either by requesting access from your Testkube representative
or by uploading the Docker image tarball artifacts.

After that, you should create a secret with the Docker registry credentials:
```bash
kubectl create secret docker-registry testkube-enterprise-registry \
  --docker-server=<your-registry-server> \
  --docker-username=<your-name>          \
  --docker-password=<your-pword>         \
  --docker-email=<your-email>            \
  --namespace=testkube-enterprise
```

### License

If you are running in an air-gaped environment, you should opt in for an Offline License which consists of a 
License Key and License File. If your environment has access to the Internet, you can use an Online License which requires 
only the License Key.

### Domain

Testkube Enterprise uses NGINX Controller to properly configure & optimize various protocols it uses.
NGINX is the only currently supported Ingress Controller and Testkube Enterprise will not work without it.

Testkube Enterprise requires a domain (public or internal) under which it will expose the following services:
* Dashboard -> https://dashboard.<your-domain>
* REST API -> https://api.<your-domain>
* Websocket API -> wss://websockets.<your-domain>
* gRPC API -> grpc://agent.<your-domain>

#### TLS

For best performance, TLS should be terminated at application level (Testkube Enterprise API) instead of NGINX/Ingress level because
gRPC and Websockets protocols perform significantly better when HTTP2 protocol is used end-to-end.
By default, NGINX downgrades HTTP2 protocol to HTTP1.1 when the backend service listens on an insecure port.

If `cert-manager` is installed in your cluster, it should be configured to issue certificates for the configured domain by using `Issuer` or `ClusterIssuer` resource.
Testkube Enterprise Helm chart needs the following config in that case:
```helm
# values.yaml
global:
  certificateProvider: "cert-manager"
  certManager:
    issuerRef: <issuer|clusterissuer name>
```

By default, Testkube Enterprise uses a `ClusterIssuer` `cert-manager` resource, that can be changed by setting the `testkube-cloud-api.api.tls.certManager.issuerKind` field to `Issuer`.

If `cert-manager` is not installed in your cluster, valid TLS certificates (for API & Dashboard) which cover the following subdomains need to be provided:
* API (tls secret name is configured with `testkube-cloud-api.api.tls.tlsSecret` field)
  * `api.<your-domain>`
  * `agent.<your-domain>`
  * `websockets.<your-domain>`
* Dashboard (TLS secret name is configured with `testkube-cloud-ui.ingress.tlsSecretName` field)
  * `dashboard.<your-domain>`
Also, `global.certificateProvider` should be set to blank ("").
```helm
# values.yaml
global:
  certificateProvider: ""
```

### Auth

Testkube Enterprise uses [Dex](https://dexidp.io/) for authentication & authorization.
For more info on how to configure Dex, refer to the [auth.md](./auth.md) document.

## Invitations

Testkube Enterprise supports inviting users to Testkube Organizations and Environments, and assigning them various roles & permissions.

### Invitations via email

If `testkube-cloud-api.api.inviteMode` is set to `email`, Testkube Enterprise will send emails when a user gets invited to
an Organization or an Environment, and in that case SMTP settings need to be configured in the API Helm chart.

```helm
# values.yaml
testkube-cloud-api:
  inviteMode: email
  smtp:
    host: <smtp host>
    port: <smtp port>
    username: <smtp username>
    password: <smtp password>
    # password can also be referenced by using the `passwordSecretRef` field which needs to contain the key SMTP_PASSWORD
    # passwordSecretRef: <secret name>
```

### Auto-accept invitations

If `testkube-cloud-api.api.inviteMode` is set to `auto-accept`, Testkube Enterprise will automatically add users to
Organizations and Environments when they get invited.

```helm
# values.yaml
testkube-cloud-api:
  inviteMode: auto-accept
```

### Minimal setup

For a minimal setup, you need to at least provide the following configuration:
```helm
# values.yaml
global:
  domain: <your domain>
  imagePullSecrets:
    - name: <docker creds secret>
  licenseKey: <your license key>
dex:
  configTemplate:
    additionalConfig: |
      staticPasswords:
        - email: <user email>
          hash: <bcrypt hash of user password>
          username: <username>
```

For a more advanced setup, refer to the Testkube Enterprise Chart [README.md](../README.md).

## Installation

1. Get the Testkube Enterprise Helm chart (TODO: add a guide for downloading from keygen.sh)
2. Create a `values.yaml` with preferred configuration
3. Run `helm install testkube-enterprise ./testkube-enterprise -f values.yaml --namespace testkube-enterprise`