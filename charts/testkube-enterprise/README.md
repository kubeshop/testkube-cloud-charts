# testkube-enterprise

![Version: 1.12.34](https://img.shields.io/badge/Version-1.12.34-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for Testkube Enterprise

**Homepage:** <https://github.com/kubeshop/testkube-cloud-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| testkube |  | <https://testkube.io> |

## Source Code

* <https://github.com/kubeshop/testkube-cloud-api>
* <https://github.com/kubeshop/testkube-cloud-ui>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../testkube-cloud-api | testkube-cloud-api | 1.14.0 |
| file://../testkube-cloud-ui | testkube-cloud-ui | 1.14.0 |
| https://charts.bitnami.com/bitnami | common | 2.2.5 |
| https://charts.bitnami.com/bitnami | mongodb | 13.10.2 |
| https://charts.dexidp.io | dex | 0.14.1 |
| https://nats-io.github.io/k8s/helm/charts/ | nats | 0.14.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| dex.configSecret.create | bool | `false` | This should be set to `false` so Dex does not create the config secret. Refer to the `createCustom` field for more info on creating config secret. |
| dex.configSecret.createCustom | bool | `true` | Toggle whether to create a custom config secret for Dex (templates/dex-config-secret.yaml). If set to `true`, the `configTemplate` field will be used to generate the config secret. |
| dex.configSecret.name | string | `"testkube-enterprise-dex-config"` | The name of the secret to mount as configuration in the pod. Set `createCustom: false` and edit the secret manually to use a custom config secret. |
| dex.configTemplate | object | `{"additionalConfig":"","base":"logger:\n  level: debug\n  format: json\nstorage:\n  type: kubernetes\n  config:\n    inCluster: true\n","customConfig":""}` | Inline Dex configuration which will be used to generate the config secret. |
| dex.configTemplate.additionalConfig | string | `""` | Additional config which will be appended to the config like `staticClients`, `staticPasswords ,`connectors`... |
| dex.configTemplate.customConfig | string | `""` | If provided, it will completely override the default config (`base` and `additionalConfig`). This is useful if you want to use a custom config file. |
| dex.enabled | bool | `true` | Toggle whether to install Dex |
| dex.fullnameOverride | string | `"testkube-enterprise-dex"` |  |
| dex.image.tag | string | `"v2.36.0-alpine"` | Dex image tag (https://ghcr.io/dexidp/dex) |
| dex.ingress.className | string | `"nginx"` | Testkube Enterprise supports only NGINX Controller currently |
| dex.ingress.enabled | bool | `true` | Toggle whether to enable ingress for Dex |
| dex.ingress.hosts[0].host | string | `"api.{{ .Values.global.domain }}"` |  |
| dex.ingress.hosts[0].paths[0].path | string | `"/idp"` |  |
| dex.ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| dex.ingress.tls[0].hosts[0] | string | `"api.{{ .Values.global.domain }}"` |  |
| dex.ingress.tls[0].secretName | string | `"testkube-enterprise-api-tls"` |  |
| dex.podSecurityContext | string | `nil` | MongoDB Pod Security Context |
| dex.resources.limits | object | `{}` |  |
| dex.resources.requests.cpu | string | `"100m"` |  |
| dex.resources.requests.memory | string | `"128Mi"` |  |
| dex.securityContext | object | `{}` | Security Context for MongoDB container |
| global.certManager.issuerRef | string | `""` | Certificate Issuer ref (only used if `provider` is set to `cert-manager`) |
| global.certificateProvider | string | `"cert-manager"` | TLS provider (possible values: "", "cert-manager") |
| global.dex.issuer | string | `"http://testkube-enterprise-dex:5556/idp"` | Global Dex issuer url which is configured both in Dex and API |
| global.domain | string | `""` | Domain under which to create Ingress rules |
| global.enterpriseLicenseFile | string | `""` | Base64-encoded Enterprise License file |
| global.enterpriseLicenseKey | string | `""` | Enterprise License key |
| global.enterpriseLicenseSecretRef | string | `""` | Enterprise License file secret ref (secret should contain a file called 'license.lic') |
| global.enterpriseMode | bool | `true` | Run Testkube in enterprise mode (enables enterprise features) |
| global.enterpriseOfflineAccess | bool | `false` | Toggle whether to enable offline license activation in Enterprise mode |
| global.grpcApiSubdomain | string | `"agent"` | gRPC API subdomain which get prepended to the domain |
| global.imagePullSecrets | list | `[]` | Image pull secrets to use for testkube-cloud-api and testkube-cloud-ui |
| global.ingress.enabled | bool | `true` | Global toggle whether to create Ingress resources |
| global.restApiSubdomain | string | `"api"` | REST API subdomain which get prepended to the domain |
| global.uiSubdomain | string | `"dashboard"` | UI subdomain which get prepended to the domain |
| global.websocketApiSubdomain | string | `"websockets"` | Websocket API subdomain which get prepended to the domain |
| mongodb.auth.enabled | bool | `false` | Toggle whether to enable MongoDB authentication |
| mongodb.containerSecurityContext | object | `{}` | Security Context for MongoDB container |
| mongodb.enabled | bool | `true` | Toggle whether to install MongoDB |
| mongodb.fullnameOverride | string | `"testkube-enterprise-mongodb"` | MongoDB fullname override |
| mongodb.podSecurityContext | object | `{}` | MongoDB Pod Security Context |
| mongodb.resources | object | `{"requests":{"cpu":"150m","memory":"128Mi"}}` | MongoDB resource settings |
| mongodb.tolerations | list | `[]` |  |
| nats.cluster.enabled | bool | `true` | Enable cluster mode (HA) |
| nats.cluster.replicas | int | `3` | NATS cluster replicas |
| nats.exporter.resources | object | `{}` | Exporter resources settings |
| nats.exporter.securityContext | object | `{}` | Security Context for Exporter container |
| nats.fullnameOverride | string | `"testkube-enterprise-nats"` |  |
| nats.nats.enabled | bool | `true` |  |
| nats.nats.limits.maxPayload | string | `"8MB"` | Max payload |
| nats.nats.resources | object | `{}` | NATS resource settings |
| nats.nats.securityContext | object | `{}` | Security Context for NATS container |
| nats.natsbox.securityContext | object | `{}` | Security Context for NATS Box container |
| nats.natsbox.tolerations | list | `[]` | NATS Box tolerations settings |
| nats.reloader.securityContext | object | `{}` | Security Context for Reloader container |
| nats.securityContext | object | `{}` | NATS Pod Security Context |
| nats.tolerations | list | `[]` |  |
| testkube-cloud-api.api.agent.hide | bool | `false` |  |
| testkube-cloud-api.api.agent.host | string | `""` | Agent host (without protocol) is used for building agent install commands (if blank, api will autogenerate it based on the value of `global.domain`) |
| testkube-cloud-api.api.agent.port | int | `443` | Agent port - used for building agent install commands |
| testkube-cloud-api.api.inviteMode | string | `"email"` | Configure which invitation mode to use (email|auto-accept): email uses SMTP protocol to send email invites and auto-accept immediately adds them |
| testkube-cloud-api.api.migrations.enabled | bool | `true` | Toggle whether to run database migrations |
| testkube-cloud-api.api.migrations.image.repository | string | `"testkubeenterprise/testkube-enterprise-api-migrations"` | Migrations image repository |
| testkube-cloud-api.api.migrations.useHelmHooks | bool | `false` | Toggle whether to enable pre-install & pre-upgrade hooks (should be disabled if mongo is installed using this chart) |
| testkube-cloud-api.api.minio.accessKeyId | string | `"testkube-enterprise"` | MinIO access key id |
| testkube-cloud-api.api.minio.credsSecretRef | string | `""` | Credentials secret ref (secret should contain keys: MINIO_ACCESS_KEY_ID, MINIO_SECRET_ACCESS_KEY, MINIO_TOKEN) (default is `testkube-cloud-minio-secret`) |
| testkube-cloud-api.api.minio.endpoint | string | `"testkube-enterprise-minio:9000"` | MinIO endpoint |
| testkube-cloud-api.api.minio.expirationPeriod | int | `0` | Expiration period in days |
| testkube-cloud-api.api.minio.region | string | `""` | S3 region |
| testkube-cloud-api.api.minio.secretAccessKey | string | `"t3stkub3-3nt3rpr1s3"` | MinIO secret access key |
| testkube-cloud-api.api.minio.secure | bool | `false` | Should be set to `true` if MinIO is exposed through HTTPS |
| testkube-cloud-api.api.minio.token | string | `""` | MinIO token |
| testkube-cloud-api.api.mongo.database | string | `"testkubeEnterpriseDB"` | Mongo database name |
| testkube-cloud-api.api.mongo.dsn | string | `"mongodb://testkube-enterprise-mongodb:27017"` | Mongo DSN connection string |
| testkube-cloud-api.api.nats.uri | string | `"nats://testkube-enterprise-nats:4222"` | NATS URI |
| testkube-cloud-api.api.oauth.clientId | string | `"testkube-enterprise"` | OAuth Client ID for the configured static client in Dex |
| testkube-cloud-api.api.oauth.clientSecret | string | `"QWkVzs3nct6HZM5hxsPzwaZtq"` | OAuth Client ID for the configured static client in Dex |
| testkube-cloud-api.api.oauth.issuerUrl | string | `""` | if oauth.secretRef is empty (""), then oauth.issuerUrl field will be used for the OAuth issuer URL |
| testkube-cloud-api.api.oauth.redirectUri | string | `""` | If oauth.secretRef is empty (""), then oauth.redirectUri field will be used for the OAuth redirect URI |
| testkube-cloud-api.api.oauth.secretRef | string | `""` | OAuth secret ref for OAuth configuration (secret must contain keys: OAUTH_CLIENT_ID, OAUTH_CLIENT_SECRET, OAUTH_ISSUER_URL, OAUTH_REDIRECT_URI) (default is `testkube-cloud-oauth-secret`) |
| testkube-cloud-api.api.outputsBucket | string | `"testkube-cloud-outputs"` | S3 bucket in which to store logs & artifacts |
| testkube-cloud-api.api.sendgrid.apiKey | string | `""` | Sendgrid API key |
| testkube-cloud-api.api.sendgrid.secretRef | string | `""` | Secret API key secret ref (secret must contain key SENDGRID_API_KEY) (default is `sendgrid-api-key`) |
| testkube-cloud-api.api.smtp.host | string | `"smtp.sendgrid.net"` | SMTP host |
| testkube-cloud-api.api.smtp.password | string | `""` | SMTP password |
| testkube-cloud-api.api.smtp.passwordSecretRef | string | `""` | SMTP secret ref (secret must contain key SMTP_PASSWORD), overrides password field if defined |
| testkube-cloud-api.api.smtp.port | int | `587` | SMTP port |
| testkube-cloud-api.api.smtp.username | string | `""` | SMTP username |
| testkube-cloud-api.api.tls.certManager.issuerKind | string | `"ClusterIssuer"` | Certificate Issuer kind (only used if `provider` is set to `cert-manager`) |
| testkube-cloud-api.api.tls.tlsSecret | string | `"testkube-enterprise-api-tls"` |  |
| testkube-cloud-api.fullnameOverride | string | `"testkube-enterprise-api"` |  |
| testkube-cloud-api.image.repository | string | `"testkubeenterprise/testkube-enterprise-api"` |  |
| testkube-cloud-api.image.tag | string | `"1.3.7"` |  |
| testkube-cloud-api.ingress | string | `nil` |  |
| testkube-cloud-api.minio.accessModes | list | `["ReadWriteOnce"]` | PVC Access Modes for Minio. The volume is mounted as read-write by a single node. |
| testkube-cloud-api.minio.affinity | object | `{}` | Affinity for pod assignment. |
| testkube-cloud-api.minio.credentials.accessKeyId | string | `"testkube-enterprise"` | Root username |
| testkube-cloud-api.minio.credentials.secretAccessKey | string | `"t3stkub3-3nt3rpr1s3"` | Root password |
| testkube-cloud-api.minio.customServiceAccountName | string | `""` | Custom service account for MinIO Deployment resource (overrides service account creation) |
| testkube-cloud-api.minio.enabled | bool | `true` | Toggle whether to install MinIO |
| testkube-cloud-api.minio.extraEnvVars | object | `{}` | Minio extra vars |
| testkube-cloud-api.minio.fullnameOverride | string | `"testkube-enterprise-minio"` |  |
| testkube-cloud-api.minio.nodeSelector | object | `{}` | Node labels for pod assignment. |
| testkube-cloud-api.minio.persistence.storage | string | `"10Gi"` | PVC Storage Request for MinIO. Should be available in the cluster. |
| testkube-cloud-api.minio.podSecurityContext | object | `{}` | MinIO Pod Security Context |
| testkube-cloud-api.minio.resources | object | `{}` | MinIO Resources settings |
| testkube-cloud-api.minio.securityContext | object | `{}` | Security Context for MinIO container |
| testkube-cloud-api.minio.serviceAccount.annotations | object | `{}` | Additional annotations to add to the ServiceAccount resource |
| testkube-cloud-api.minio.serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| testkube-cloud-api.minio.serviceAccount.labels | object | `{}` | Additional labels to add to the ServiceAccount resource |
| testkube-cloud-api.minio.serviceAccount.name | string | `""` | The name of the service account to use. |
| testkube-cloud-api.minio.tolerations | list | `[]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| testkube-cloud-api.prometheus.enabled | bool | `true` |  |
| testkube-cloud-ui.fullnameOverride | string | `"testkube-enterprise-ui"` |  |
| testkube-cloud-ui.image.repository | string | `"testkubeenterprise/testkube-enterprise-ui"` |  |
| testkube-cloud-ui.image.tag | string | `"1.4.0-dev-f443d5d"` |  |
| testkube-cloud-ui.ingress.tlsSecretName | string | `"testkube-enterprise-ui-tls"` | Name of the TLS secret which contains the certificate files |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
