## Getting started

### Minimal configuration

Dex requires a minimal configuration in order to work.
You can pass configuration to Dex using Helm values:

```yaml
config:
  # Set it to a valid URL
  issuer: http://my-issuer-url.com

  # See https://dexidp.io/docs/storage/ for more options
  storage:
    type: memory

  # Enable at least one connector
  # See https://dexidp.io/docs/connectors/ for more options
  enablePasswordDB: true
```

The above configuration won't make Dex automatically available on the configured URL.
One (and probably the easiest) way to achieve that is configuring ingress:

```yaml
ingress:
  enabled: true

  hosts:
    - host: my-issuer-url.com
      paths:
        - path: /
```

### Minimal TLS configuration

HTTPS is basically mandatory these days, especially for authentication and authorization services.
There are several solutions for protecting services with TlS in Kubernetes,
but by far the most popular and portable is undoubtedly [Cert Manager](https://cert-manager.io).

Cert Manager can be [installed](https://cert-manager.io/docs/installation/kubernetes) with a few steps:

```shell
helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl create namespace cert-manager
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --set installCRDs=true
```

The next step is setting up an [issuer](https://cert-manager.io/docs/concepts/issuer/) (eg. [Let's Encrypt](https://letsencrypt.org/)):

```shell
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: acme
spec:
  acme:
    email: YOUR@EMAIL_ADDRESS
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: acme-account-key
    solvers:
    - http01:
       ingress:
         class: YOUR_INGRESS_CLASS
EOF
```

Finally, change the ingress config to use TLS:

```yaml
ingress:
  enabled: true

  annotations:
    cert-manager.io/cluster-issuer: acme

  hosts:
    - host: my-issuer-url.com
      paths:
        - path: /

  tls:
    - hosts:
        - my-issuer-url.com
      secretName: dex-cert
```

## Migrating from stable/dex (or banzaicloud-stable/dex) chart

This chart is not backwards compatible with the `stable/dex` (or `banzaicloud-stable/dex`) chart.

However, Dex itself remains backwards compatible, so you can easily install the new chart in place of the old one
and continue using Dex with a minimal downtime.
