# testkube-enterprise

![Version: 1.43.7](https://img.shields.io/badge/Version-1.43.7-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for Testkube Enterprise

**Homepage:** <https://github.com/kubeshop/testkube-cloud-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| testkube |  | <https://testkube.io> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../testkube-cloud-api | testkube-cloud-api | 1.29.11 |
| file://../testkube-cloud-ui | testkube-cloud-ui | 1.24.5 |
| https://charts.bitnami.com/bitnami | common | 2.13.3 |
| https://charts.bitnami.com/bitnami | minio | 12.10.2 |
| https://charts.bitnami.com/bitnami | mongodb | 14.3.0 |
| https://charts.dexidp.io | dex | 0.15.3 |
| https://nats-io.github.io/k8s/helm/charts/ | nats | 1.1.5 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| dex.configSecret.create | bool | `false` | This should be set to `false` so Dex does not create the config secret. Refer to the `createCustom` field for more info on creating config secret. |
| dex.configSecret.createCustom | bool | `true` | Toggle whether to create a custom config secret for Dex (templates/dex-config-secret.yaml). If set to `true`, the `configTemplate` field will be used to generate the config secret. |
| dex.configSecret.name | string | `"testkube-enterprise-dex-config"` | The name of the secret to mount as configuration in the pod. Set `createCustom: false` and edit the secret manually to use a custom config secret. |
| dex.configTemplate | object | `{"additionalConfig":"","base":"logger:\n  level: debug\n  format: json\n","customConfig":""}` | Inline Dex configuration which will be used to generate the config secret. |
| dex.configTemplate.additionalConfig | string | `""` | Additional config which will be appended to the config like `staticClients`, `staticPasswords ,`connectors`... |
| dex.configTemplate.customConfig | string | `""` | If provided, it will completely override the default config (`base` and `additionalConfig`). This is useful if you want to use a custom config file. |
| dex.enabled | bool | `true` | Toggle whether to install Dex |
| dex.fullnameOverride | string | `"testkube-enterprise-dex"` |  |
| dex.ingress.annotations | object | `{}` | Additional annotations for Dex ingress |
| dex.ingress.className | string | `"nginx"` | Testkube Enterprise supports only NGINX Controller currently |
| dex.ingress.enabled | bool | `true` | Toggle whether to enable ingress for Dex |
| dex.ingress.hosts[0].host | string | `"{{ .Values.global.restApiSubdomain }}.{{ .Values.global.domain }}"` |  |
| dex.ingress.hosts[0].paths[0].path | string | `"/idp"` |  |
| dex.ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| dex.ingress.tls[0].hosts[0] | string | `"{{ .Values.global.restApiSubdomain }}.{{ .Values.global.domain }}"` |  |
| dex.ingress.tls[0].secretName | string | `"testkube-enterprise-api-tls"` |  |
| dex.podSecurityContext | string | `nil` | MongoDB Pod Security Context |
| dex.rbac.create | bool | `true` | Specifies whether RBAC resources should be created. If disabled, the operator is responsible for creating the necessary resources based on the templates. |
| dex.rbac.createClusterScoped | bool | `true` | Specifies which RBAC resources should be created. If disabled, the operator is responsible for creating the necessary resources (ClusterRole and RoleBinding or CRD's) |
| dex.resources.limits | object | `{}` |  |
| dex.resources.requests.cpu | string | `"100m"` |  |
| dex.resources.requests.memory | string | `"128Mi"` |  |
| dex.securityContext | object | `{}` | Security Context for MongoDB container |
| dex.storage | object | `{}` | Configure backend for Dex internal config (more info here https://dexidp.io/docs/storage) |
| global.certManager.issuerRef | string | `""` | Certificate Issuer ref (only used if `provider` is set to `cert-manager`) |
| global.certificateProvider | string | `"cert-manager"` | TLS certificate provider. Set to "cert-manager" for integration with cert-manager or leave empty for other methods |
| global.dex.issuer | string | `""` | Global Dex issuer url which is configured both in Dex and API |
| global.domain | string | `""` | Domain under which to create Ingress rules |
| global.enterpriseLicenseFile | string | `""` | Base64-encoded Enterprise License file |
| global.enterpriseLicenseKey | string | `""` | Enterprise License key |
| global.enterpriseLicenseSecretRef | string | `""` | Enterprise License file secret ref (secret should contain a file called 'license.lic') |
| global.enterpriseMode | bool | `true` | Run Testkube in enterprise mode (enables enterprise features) |
| global.enterpriseOfflineAccess | bool | `false` | Toggle whether to enable offline license activation in Enterprise mode |
| global.grpcApiSubdomain | string | `"agent"` | gRPC API subdomain which get prepended to the domain |
| global.imagePullSecrets | list | `[]` | Image pull secrets to use for testkube-cloud-api and testkube-cloud-ui |
| global.ingress.enabled | bool | `true` | Global toggle whether to create Ingress resources |
| global.redirectSubdomain | string | `"app"` | Different UI subdomain which gets prepended to the domain. May be used for the redirect from your actual uiSubdomain endpoint. Works is ingressRedirect option is enabled. |
| global.restApiSubdomain | string | `"api"` | REST API subdomain which get prepended to the domain |
| global.statusPagesApiSubdomain | string | `"status"` | Status Pages API subdomain which get prepended to the domain |
| global.storageApiSubdomain | string | `"storage"` | Storage API subdomain which get prepended to the domain |
| global.uiSubdomain | string | `"dashboard"` | UI subdomain which get prepended to the domain |
| global.websocketApiSubdomain | string | `"websockets"` | Websocket API subdomain which get prepended to the domain |
| minio.affinity | object | `{}` | Affinity for pod assignment. |
| minio.auth.existingSecret | string | `""` | Use existing secret for credentials details (`auth.rootUser` and `auth.rootPassword` will be ignored and picked up from this secret). The secret has to contain the keys `root-user` and `root-password`) |
| minio.auth.rootPassword | string | `"t3stkub3-3nt3rpr1s3"` | MinIO root password (secret key) |
| minio.auth.rootUser | string | `"testkube-enterprise"` | MinIO root username (access key) |
| minio.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| minio.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| minio.containerSecurityContext.enabled | bool | `true` | Toggle whether to render the container security context |
| minio.containerSecurityContext.privileged | bool | `false` |  |
| minio.containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| minio.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| minio.containerSecurityContext.runAsUser | int | `1001` |  |
| minio.containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| minio.customIngress.annotations | object | `{}` | Additional annotations to add to the MinIO Ingress resource |
| minio.customIngress.className | string | `"nginx"` | Ingress class name |
| minio.customIngress.enabled | bool | `true` | Toggle whether to enable the MinIO Ingress |
| minio.customIngress.endpoint | string | `"testkube-enterprise-minio"` | MinIO endpoint used in the Ingress |
| minio.customIngress.host | string | `""` | Hostname for which to create rules and TLS certificates (if omitted, the host will be generated using the global subdomain and `domain` values) |
| minio.customIngress.labels | object | `{}` | Additional labels to add to the MinIO Ingress resource |
| minio.customIngress.tls.tlsSecret | string | `"testkube-enterprise-minio-tls"` | TLS secret name which contains the certificate files |
| minio.disableWebUI | bool | `false` | Disable MinIO Web UI |
| minio.enabled | bool | `true` | To |
| minio.extraEnvVars | list | `[]` |  |
| minio.fullnameOverride | string | `"testkube-enterprise-minio"` |  |
| minio.metrics.serviceMonitor.enabled | bool | `false` | Toggle whether to create ServiceMonitor resource for scraping metrics using Prometheus Operator |
| minio.nodeSelector | object | `{}` | Node labels for pod assignment. |
| minio.podSecurityContext.enabled | bool | `true` | Toggle whether to render the pod security context |
| minio.podSecurityContext.fsGroup | int | `1001` |  |
| minio.tls.autoGenerated | bool | `false` | Generate automatically self-signed TLS certificates |
| minio.tls.enabled | bool | `false` | Enable tls in front of the container |
| minio.tls.existingSecret | string | `""` | Name of an existing secret holding the certificate information |
| minio.tolerations | list | `[]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| mongodb.auth.enabled | bool | `false` | Toggle whether to enable MongoDB authentication |
| mongodb.containerSecurityContext | object | `{}` | Security Context for MongoDB container |
| mongodb.enabled | bool | `true` | Toggle whether to install MongoDB |
| mongodb.fullnameOverride | string | `"testkube-enterprise-mongodb"` | MongoDB fullname override |
| mongodb.podSecurityContext | object | `{}` | MongoDB Pod Security Context |
| mongodb.resources | object | `{"requests":{"cpu":"150m","memory":"128Mi"}}` | MongoDB resource settings |
| mongodb.tolerations | list | `[]` |  |
| nats.config.cluster.enabled | bool | `true` | Enable cluster mode (HA) |
| nats.config.cluster.replicas | int | `3` | NATS cluster replicas |
| nats.config.jetstream.enabled | bool | `true` |  |
| nats.config.jetstream.fileStore.pvc.enabled | bool | `true` |  |
| nats.config.jetstream.fileStore.pvc.size | string | `"10Gi"` |  |
| nats.config.jetstream.fileStore.pvc.storageClassName | string | `nil` |  |
| nats.config.merge | object | `{"cluster":{"name":"<< testkube-enterprise >>"},"max_payload":"<< 8MB >>"}` | Merge additional fields to nats config https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#container-v1-core |
| nats.config.patch | list | `[]` | Patch additional fields to nats config |
| nats.fullnameOverride | string | `"testkube-enterprise-nats"` |  |
| nats.natsBox.enabled | bool | `true` |  |
| nats.natsBox.env | object | `{}` | Map of additional env vars |
| nats.natsBox.merge | object | `{}` | Merge additional fields to the container https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#container-v1-core |
| nats.natsBox.patch | list | `[]` | Patch additional fields to the container |
| nats.promExporter.enabled | bool | `true` | Toggle whether to install NATS exporter |
| nats.promExporter.env | object | `{}` | Map of additional env vars |
| nats.promExporter.merge | object | `{}` | Merge additional fields to the container https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#container-v1-core |
| nats.promExporter.patch | list | `[]` | Patch additional fields to the container |
| nats.reloader.enabled | bool | `true` | Toggle whether to install Reloader |
| nats.reloader.env | object | `{}` | Map of additional env vars |
| nats.reloader.merge | object | `{}` | Merge additional fields to the container https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#container-v1-core |
| nats.reloader.patch | list | `[]` | Patch additional fields to the container |
| testkube-cloud-api.ai.secretRef | string | `""` |  |
| testkube-cloud-api.api.agent.hide | bool | `false` |  |
| testkube-cloud-api.api.agent.host | string | `""` | Agent host (without protocol) is used for building agent install commands (if blank, api will autogenerate it based on the value of `global.domain`) |
| testkube-cloud-api.api.agent.port | int | `443` | Agent port - used for building agent install commands |
| testkube-cloud-api.api.inviteMode | string | `"email"` | Configure which invitation mode to use (email|auto-accept): email uses SMTP protocol to send email invites and auto-accept immediately adds them |
| testkube-cloud-api.api.migrations.enabled | bool | `false` | Toggle whether to run database migrations |
| testkube-cloud-api.api.migrations.image.repository | string | `"testkubeenterprise/testkube-enterprise-api-migrations"` | Migrations image repository |
| testkube-cloud-api.api.migrations.ttlSecondsAfterFinished | int | `90` |  |
| testkube-cloud-api.api.migrations.useHelmHooks | bool | `false` | Toggle whether to enable pre-install & pre-upgrade hooks (should be disabled if mongo is installed using this chart) |
| testkube-cloud-api.api.minio.accessKeyId | string | `"testkube-enterprise"` | MinIO access key id |
| testkube-cloud-api.api.minio.credsSecretRef | string | `""` | Credentials secret ref (secret should contain keys: root-user, root-password, token) (default is `testkube-cloud-minio-secret`) |
| testkube-cloud-api.api.minio.endpoint | string | `"{{ .Values.global.storageApiSubdomain }}.{{ .Values.global.domain }}"` | Define the MinIO service endpoint. Leave empty to auto-generate when using bundled MinIO. Specify if using an external MinIO service |
| testkube-cloud-api.api.minio.expirationPeriod | int | `0` | Expiration period in days |
| testkube-cloud-api.api.minio.region | string | `""` | S3 region |
| testkube-cloud-api.api.minio.secretAccessKey | string | `"t3stkub3-3nt3rpr1s3"` | MinIO secret access key |
| testkube-cloud-api.api.minio.secure | bool | `true` | Should be set to `true` if MinIO is exposed through HTTPS |
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
| testkube-cloud-api.api.smtp.host | string | `""` | SMTP host |
| testkube-cloud-api.api.smtp.password | string | `""` | SMTP password |
| testkube-cloud-api.api.smtp.passwordSecretRef | string | `""` | SMTP secret ref (secret must contain key SMTP_PASSWORD), overrides password field if defined |
| testkube-cloud-api.api.smtp.port | int | `587` | SMTP port |
| testkube-cloud-api.api.smtp.username | string | `""` | SMTP username |
| testkube-cloud-api.api.tls.certManager.issuerKind | string | `"ClusterIssuer"` | Certificate Issuer kind (only used if `provider` is set to `cert-manager`) |
| testkube-cloud-api.api.tls.tlsSecret | string | `"testkube-enterprise-api-tls"` |  |
| testkube-cloud-api.fullnameOverride | string | `"testkube-enterprise-api"` |  |
| testkube-cloud-api.image.repository | string | `"testkubeenterprise/testkube-enterprise-api"` |  |
| testkube-cloud-api.image.tag | string | `"1.9.0"` |  |
| testkube-cloud-api.ingress.className | string | `"nginx"` |  |
| testkube-cloud-api.prometheus.enabled | bool | `false` |  |
| testkube-cloud-ui.fullnameOverride | string | `"testkube-enterprise-ui"` |  |
| testkube-cloud-ui.image.repository | string | `"testkubeenterprise/testkube-enterprise-ui"` |  |
| testkube-cloud-ui.image.tag | string | `"1.7.8"` |  |
| testkube-cloud-ui.ingress.tlsSecretName | string | `"testkube-enterprise-ui-tls"` | Name of the TLS secret which contains the certificate files |
| testkube-cloud-ui.ingressRedirect | object | `{"enabled":false}` | Toggle whether to enable redirect Ingress which allows having a different subdomain redirecting to the actual Dashboard UI Ingress URL |
| testkube-cloud-ui.ui.authStrategy | string | `""` | Auth strategy to use (possible values: "" (default), "gitlab", "github"), setting to "" enables all auth strategies, if you use a custom Dex connector, set this to the id of the connector |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
