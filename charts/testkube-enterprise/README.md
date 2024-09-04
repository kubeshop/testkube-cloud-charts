# testkube-enterprise

![Version: 1.149.4](https://img.shields.io/badge/Version-1.149.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for Testkube Enterprise

**Homepage:** <https://github.com/kubeshop/testkube-cloud-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| testkube |  | <https://testkube.io> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../testkube-cloud-api | testkube-cloud-api | 1.80.2 |
| file://../testkube-cloud-ui | testkube-cloud-ui | 1.60.0 |
| file://../testkube-worker-service | testkube-worker-service | 1.40.0 |
| file://./charts/dex | dex | 0.18.0 |
| https://charts.bitnami.com/bitnami | common | 2.13.3 |
| https://charts.bitnami.com/bitnami | minio | 14.7.0 |
| https://charts.bitnami.com/bitnami | mongodb | 15.6.16 |
| https://kubeshop.github.io/helm-charts | testkube-agent(testkube) | 2.1.13 |
| https://nats-io.github.io/k8s/helm/charts/ | nats | 1.2.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| dex.commonLabels | object | `{}` | Common labels which will be added to all Dex resources |
| dex.configSecret.create | bool | `false` | This should be set to `false` so Dex does not create the config secret. Refer to the `createCustom` field for more info on creating config secret. |
| dex.configSecret.createCustom | bool | `true` | Toggle whether to create a custom config secret for Dex (templates/dex-config-secret.yaml). If set to `true`, the `configTemplate` field will be used to generate the config secret. |
| dex.configSecret.name | string | `"testkube-enterprise-dex-config"` | The name of the secret to mount as configuration in the pod. Set `createCustom: false` and edit the secret manually to use a custom config secret. |
| dex.configTemplate | object | `{"additionalConfig":"","additionalStaticClients":[],"base":"logger:\n  level: debug\n  format: json\n","customConfig":""}` | Inline Dex configuration which will be used to generate the config secret. |
| dex.configTemplate.additionalConfig | string | `""` | Additional config which will be appended to the config like `staticClients`, `staticPasswords ,`connectors`... |
| dex.configTemplate.additionalStaticClients | list | `[]` | Additional static clients which will be appended to the dex staticClients config |
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
| dex.podSecurityContext | object | `{}` | Dex Pod Security Context |
| dex.rbac.create | bool | `true` | Specifies whether RBAC resources should be created. If disabled, the operator is responsible for creating the necessary resources based on the templates. |
| dex.rbac.createClusterScoped | bool | `true` | Specifies which RBAC resources should be created. If disabled, the operator is responsible for creating the necessary resources (ClusterRole and RoleBinding or CRD's) |
| dex.resources | object | `{"limits":{"cpu":"250m","memory":"392Mi"},"requests":{"cpu":"50m","memory":"64Mi"}}` | Set resources requests and limits for Dex Service |
| dex.securityContext | object | `{}` | Security Context for Dex container |
| dex.storage | object | `{}` | Configure backend for Dex internal config (more info here https://dexidp.io/docs/storage) |
| global.certManager.issuerRef | string | `""` | Certificate Issuer ref (only used if `provider` is set to `cert-manager`) |
| global.certificateProvider | string | `"cert-manager"` | TLS certificate provider. Set to "cert-manager" for integration with cert-manager or leave empty for other methods |
| global.customCaSecretRef | string | `""` | Custom CA to use as a trusted CA during TLS connections. Specify a secret with the PEM encoded CA under the ca.crt key. |
| global.dex.issuer | string | `""` | Global Dex issuer url which is configured both in Dex and API |
| global.domain | string | `""` | Domain under which endpoints are exposed |
| global.enterpriseLicenseFile | string | `""` | This field is deprecated. To specify an offline license file use `enterpriseLicenseSecretRef`. |
| global.enterpriseLicenseKey | string | `""` | Specifies the enterprise license key, when using an offline license use `enterpriseLicenseSecretRef` and leave this field empty. |
| global.enterpriseLicenseSecretRef | string | `""` | Enterprise license file secret reference. Place the license key under the key `LICENSE_KEY` key in the secret, and in case of an offline license place the license file under the key `license.lic` in the same secret. Make sure that the license key file does not have any new line characters at the end of the file. |
| global.enterpriseMode | bool | `true` | Run Testkube in enterprise mode (enables enterprise features) |
| global.enterpriseOfflineAccess | bool | `false` | Toggle whether to enable offline license activation in Enterprise mode |
| global.grpcApiSubdomain | string | `"agent"` | gRPC API subdomain which get prepended to the domain |
| global.imagePullSecrets | list | `[]` | Image pull secrets to use for testkube-cloud-api and testkube-cloud-ui |
| global.imageRegistry | string | `""` | Global image registry to be prepended for to all images (usually defined in parent chart) |
| global.ingress.enabled | bool | `true` | Global toggle whether to create Ingress resources |
| global.labels | object | `{}` | Common labels which will be added to all resources |
| global.mongo.allowDiskUse | bool | `false` | Allow or prohibit writing temporary files on disk when a pipeline stage exceeds the 100 megabyte limit. |
| global.mongo.database | string | `"testkubeEnterpriseDB"` | Mongo database name |
| global.mongo.dsn | string | `"mongodb://testkube-enterprise-mongodb:27017"` | Mongo DSN connection string |
| global.mongo.dsnSecretRef | string | `""` | Mongo DSN connection string secret ref (secret must contain key MONGO_DSN) (default is `mongo-dsn`) |
| global.mongo.readPreference | string | `"secondaryPreferred"` | Mongo read preference (primary|primaryPreferred|secondary|secondaryPreferred|nearest) |
| global.nats.uri | string | `"nats://testkube-enterprise-nats:4222"` | NATS URI |
| global.redirectSubdomain | string | `"app"` | Different UI subdomain which gets prepended to the domain. May be used for the redirect from your actual uiSubdomain endpoint. Works is ingressRedirect option is enabled. |
| global.restApiSubdomain | string | `"api"` | REST API subdomain which get prepended to the domain |
| global.storage.accessKeyId | string | `"testkube-enterprise"` | S3 Access Key ID |
| global.storage.credsSecretRef | string | `""` | Credentials secret ref (secret should contain keys: root-user, root-password, token) (default is `testkube-cloud-minio-secret`) |
| global.storage.endpoint | string | `"{{ .Values.global.storageApiSubdomain }}.{{ .Values.global.domain }}"` | Endpoint to a S3 compatible storage service (without protocol) |
| global.storage.outputsBucket | string | `"testkube-cloud-outputs"` | S3 bucket in which Test Artifacts & Logs will be stored |
| global.storage.region | string | `""` | S3 region |
| global.storage.secretAccessKey | string | `"t3stkub3-3nt3rpr1s3"` | S3 Secret Access Key |
| global.storage.secure | bool | `true` | Toggle whether to use HTTPS when connecting to the S3 server |
| global.storage.skipVerify | bool | `false` | Toggle whether to skip verifying TLS certificates |
| global.storage.token | string | `""` | S3 Token |
| global.storageApiSubdomain | string | `"storage"` | Storage API subdomain which get prepended to the domain |
| global.tls | object | `{}` |  |
| global.uiSubdomain | string | `"dashboard"` | UI subdomain which get prepended to the domain |
| global.websocketApiSubdomain | string | `"websockets"` | Websocket API subdomain which get prepended to the domain |
| minio.affinity | object | `{}` | Affinity for pod assignment. |
| minio.auth.existingSecret | string | `""` | Use existing secret for credentials details (`auth.rootUser` and `auth.rootPassword` will be ignored and picked up from this secret). The secret has to contain the keys `root-user` and `root-password`) |
| minio.auth.rootPassword | string | `"t3stkub3-3nt3rpr1s3"` | MinIO root password (secret key) |
| minio.auth.rootUser | string | `"testkube-enterprise"` | MinIO root username (access key) |
| minio.commonLabels | object | `{}` | Common labels which will be added to all MinIO resources |
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
| minio.enabled | bool | `true` | Toggle whether to install MinIO |
| minio.extraEnvVars | list | `[]` |  |
| minio.fullnameOverride | string | `"testkube-enterprise-minio"` |  |
| minio.metrics.serviceMonitor.enabled | bool | `false` | Toggle whether to create ServiceMonitor resource for scraping metrics using Prometheus Operator |
| minio.nodeSelector | object | `{}` | Node labels for pod assignment. |
| minio.podSecurityContext.enabled | bool | `true` | Toggle whether to render the pod security context |
| minio.podSecurityContext.fsGroup | int | `1001` |  |
| minio.resources | object | `{"limits":{"cpu":2,"memory":"2Gi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Set resources requests and limits for MinIO |
| minio.tls.autoGenerated | bool | `false` | Generate automatically self-signed TLS certificates |
| minio.tls.enabled | bool | `false` | Enable tls in front of the container |
| minio.tls.existingSecret | string | `""` | Name of an existing secret holding the certificate information |
| minio.tolerations | list | `[]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| mongodb.auth.enabled | bool | `false` | Toggle whether to enable MongoDB authentication |
| mongodb.commonLabels | object | `{}` | Common labels which will be added to all MongoDB resources |
| mongodb.containerSecurityContext | object | `{}` | Security Context for MongoDB container |
| mongodb.enabled | bool | `true` | Toggle whether to install MongoDB |
| mongodb.fullnameOverride | string | `"testkube-enterprise-mongodb"` | MongoDB fullname override |
| mongodb.image.registry | string | `"docker.io"` |  |
| mongodb.image.repository | string | `"kubeshop/bitnami-mongodb"` |  |
| mongodb.image.tag | string | `"7.0.12"` |  |
| mongodb.podSecurityContext | object | `{}` | MongoDB Pod Security Context |
| mongodb.resources | object | `{"limits":{"cpu":2,"memory":"2Gi"},"requests":{"cpu":"150m","memory":"256Mi"}}` | Set resources requests and limits for MongoDB |
| mongodb.tolerations | list | `[]` |  |
| mongodb.updateStrategy.type | string | `"Recreate"` | Update Strategy type |
| nats.config.cluster.enabled | bool | `true` | Enable cluster mode (HA) |
| nats.config.cluster.replicas | int | `3` | NATS cluster replicas |
| nats.config.jetstream.enabled | bool | `true` | Toggle whether to enable JetStream (Testkube requires JetStream to be enabled, so this setting should always be on) |
| nats.config.jetstream.fileStore.pvc.enabled | bool | `true` |  |
| nats.config.jetstream.fileStore.pvc.size | string | `"10Gi"` |  |
| nats.config.jetstream.fileStore.pvc.storageClassName | string | `nil` |  |
| nats.config.merge | object | `{"cluster":{"name":"<< testkube-enterprise >>"},"debug":false,"max_payload":"<< 8MB >>"}` | Merge additional fields to nats config https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#container-v1-core |
| nats.config.merge.cluster.name | string | `"<< testkube-enterprise >>"` | NATS cluster name |
| nats.config.merge.debug | bool | `false` | Enable debug for NATS |
| nats.config.merge.max_payload | string | `"<< 8MB >>"` | NATS message maximum payload size |
| nats.config.patch | list | `[]` | Patch additional fields to nats config |
| nats.container.merge.resources | object | `{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"50m","memory":"64Mi"}}` | Set resources requests and limits for NATS container |
| nats.enabled | bool | `true` | Toggle whether to install NATS |
| nats.fullnameOverride | string | `"testkube-enterprise-nats"` |  |
| nats.natsBox.container.merge | object | `{"resources":{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"50m","memory":"64Mi"}}}` | Merge additional fields to the container |
| nats.natsBox.enabled | bool | `false` |  |
| nats.natsBox.env | object | `{}` | Map of additional env vars |
| nats.natsBox.merge | object | `{}` | Merge additional fields to the container https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#container-v1-core |
| nats.natsBox.patch | list | `[]` | Patch additional fields to the container |
| nats.promExporter.enabled | bool | `true` | Toggle whether to install NATS exporter |
| nats.promExporter.env | object | `{}` | Map of additional env vars |
| nats.promExporter.merge | object | `{}` | Merge additional fields to the container https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#container-v1-core |
| nats.promExporter.patch | list | `[]` | Patch additional fields to the container |
| nats.reloader.enabled | bool | `true` | Toggle whether to install Reloader |
| nats.reloader.env | object | `{}` | Map of additional env vars |
| nats.reloader.merge | object | `{"resources":{"limits":{"cpu":"100m","memory":"256Mi"},"requests":{"cpu":"50m","memory":"64Mi"}}}` | Merge additional fields to the container https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/#container-v1-core |
| nats.reloader.patch | list | `[]` |  |
| sharedSecretGenerator.containerSecurityContext | object | `{}` | Container Security Context for the Shared Secret Generator Job |
| sharedSecretGenerator.enabled | bool | `false` | Toggle whether to enable the Shared Secret Generator Job |
| sharedSecretGenerator.image.registry | string | `"docker.io"` |  |
| sharedSecretGenerator.image.repository | string | `"bitnami/kubectl"` |  |
| sharedSecretGenerator.image.tag | string | `"1.28.2"` |  |
| sharedSecretGenerator.resources | object | `{}` | Resources for the Shared Secret Generator Job |
| sharedSecretGenerator.securityContext | object | `{}` | Pod Security Context for the Shared Secret Generator Job |
| testkube-agent.enabled | bool | `false` | Toggle whether to install & connect Testkube Agent in the same cluster |
| testkube-cloud-api.ai.secretRef | string | `""` |  |
| testkube-cloud-api.api.agent.healthcheck.lock | string | `"kv"` | Agent healthcheck distributed mode (one of mongo|kv) - used for pods sync to run healthchecks on single pod at once |
| testkube-cloud-api.api.agent.hide | bool | `false` |  |
| testkube-cloud-api.api.agent.host | string | `""` | Agent host (without protocol) is used for building agent install commands (if blank, api will autogenerate it based on the value of `global.domain`) |
| testkube-cloud-api.api.agent.keepAlive | bool | `false` | Toggle whether to enable agent grpc keepalive pings |
| testkube-cloud-api.api.agent.port | int | `443` | Agent port - used for building agent install commands |
| testkube-cloud-api.api.debug.enableGrpcServerLogs | bool | `false` | Toggle whether to enable gRPC server logs |
| testkube-cloud-api.api.debug.enableHttp2Logs | bool | `false` | Toggle whether to enable debug logs by setting the GODEBUG=http2debug=2 |
| testkube-cloud-api.api.email.fromEmail | string | `""` | Email to use for sending outgoing emails |
| testkube-cloud-api.api.email.fromName | string | `""` | Name to use for sending outgoing emails |
| testkube-cloud-api.api.features.disablePersonalOrgs | bool | `false` | Toggle whether to disable personal organizations when a user signs up for the first time |
| testkube-cloud-api.api.features.legacyTests | bool | `false` | Toggle whether to enable support for legacy tests (Test, TestSuite) |
| testkube-cloud-api.api.inviteMode | string | `"auto-accept"` | Configure which invitation mode to use (email|auto-accept): email uses SMTP protocol to send email invites and auto-accept immediately adds them |
| testkube-cloud-api.api.logServer | object | `{"caFile":"","certFile":"","enabled":false,"grpcAddress":"testkube-enterprise-logs-service:8089","keyFile":"","secure":"false","skipVerify":"true"}` | External log server connection configuration |
| testkube-cloud-api.api.logServer.caFile | string | `""` | TLS CA certificate file |
| testkube-cloud-api.api.logServer.certFile | string | `""` | TLS certificate file |
| testkube-cloud-api.api.logServer.enabled | bool | `false` | Toggle whether to enable external log server connection |
| testkube-cloud-api.api.logServer.grpcAddress | string | `"testkube-enterprise-logs-service:8089"` | Log server address |
| testkube-cloud-api.api.logServer.keyFile | string | `""` | TLS key file |
| testkube-cloud-api.api.logServer.secure | string | `"false"` | Log server TLS configuration secure connection |
| testkube-cloud-api.api.logServer.skipVerify | string | `"true"` | Log server TLS configuration skip Verify |
| testkube-cloud-api.api.migrations.enabled | bool | `true` | Toggle whether to run database migrations |
| testkube-cloud-api.api.migrations.image.repository | string | `"kubeshop/testkube-enterprise-api-migrations"` | Migrations image repository |
| testkube-cloud-api.api.migrations.ttlSecondsAfterFinished | int | `90` |  |
| testkube-cloud-api.api.migrations.useHelmHooks | bool | `false` | Toggle whether to enable pre-install & pre-upgrade hooks (should be disabled if mongo is installed using this chart) |
| testkube-cloud-api.api.minio.certSecret.baseMountPath | string | `"/etc/client-certs/storage"` | Base path to mount the client certificate secret |
| testkube-cloud-api.api.minio.certSecret.caFile | string | `"ca.crt"` | Path to ca file (used for self-signed certificates) |
| testkube-cloud-api.api.minio.certSecret.certFile | string | `"cert.crt"` | Path to client certificate file |
| testkube-cloud-api.api.minio.certSecret.enabled | bool | `false` | Toggle whether to mount k8s secret which contains storage client certificate (cert.crt, cert.key, ca.crt) |
| testkube-cloud-api.api.minio.certSecret.keyFile | string | `"cert.key"` | Path to client certificate key file |
| testkube-cloud-api.api.minio.certSecret.name | string | `"storage-client-cert"` | Name of the storage client certificate secret |
| testkube-cloud-api.api.minio.credsFilePath | string | `""` | Path to where a Minio credential file should be mounted |
| testkube-cloud-api.api.minio.expirationPeriod | int | `0` | Expiration period in days |
| testkube-cloud-api.api.minio.mountCACertificate | bool | `false` | If enabled, will also require a CA certificate to be provided |
| testkube-cloud-api.api.minio.signing.hostname | string | `""` | Hostname for the presigned PUT URL |
| testkube-cloud-api.api.minio.signing.secure | bool | `false` | Toggle should the presigned URL use HTTPS |
| testkube-cloud-api.api.mongo.allowDiskUse | bool | `false` | Allow or prohibit writing temporary files on disk when a pipeline stage exceeds the 100 megabyte limit. |
| testkube-cloud-api.api.mongo.database | string | `"testkubeEnterpriseDB"` | Mongo database name |
| testkube-cloud-api.api.mongo.dsn | string | `"mongodb://testkube-enterprise-mongodb:27017"` | Mongo DSN connection string |
| testkube-cloud-api.api.mongo.dsnSecretRef | string | `""` | Mongo DSN connection string secret ref (secret must contain key MONGO_DSN) (default is `mongo-dsn`) |
| testkube-cloud-api.api.mongo.readPreference | string | `"secondaryPreferred"` | Mongo read preference (primary|primaryPreferred|secondary|secondaryPreferred|nearest) |
| testkube-cloud-api.api.nats.uri | string | `"nats://testkube-enterprise-nats:4222"` | NATS URI |
| testkube-cloud-api.api.oauth.clientId | string | `"testkube-enterprise"` | OAuth Client ID for the configured static client in Dex |
| testkube-cloud-api.api.oauth.clientSecret | string | `"QWkVzs3nct6HZM5hxsPzwaZtq"` | OAuth Client ID for the configured static client in Dex |
| testkube-cloud-api.api.oauth.issuerUrl | string | `""` | if oauth.secretRef is empty (""), then oauth.issuerUrl field will be used for the OAuth issuer URL |
| testkube-cloud-api.api.oauth.redirectUri | string | `""` | If oauth.secretRef is empty (""), then oauth.redirectUri field will be used for the OAuth redirect URI |
| testkube-cloud-api.api.oauth.secretRef | string | `""` | OAuth secret ref for OAuth configuration (secret must contain keys: OAUTH_CLIENT_ID, OAUTH_CLIENT_SECRET, OAUTH_ISSUER_URL, OAUTH_REDIRECT_URI) (default is `testkube-cloud-oauth-secret`) |
| testkube-cloud-api.api.oauth.skipVerify | bool | `false` | Toggle whether to skip TLS verification for OAuth issuer |
| testkube-cloud-api.api.outputsBucket | string | `"testkube-cloud-outputs"` | S3 bucket in which to store logs & artifacts |
| testkube-cloud-api.api.sendgrid.apiKey | string | `""` | Sendgrid API key |
| testkube-cloud-api.api.sendgrid.secretRef | string | `""` | Secret API key secret ref (secret must contain key SENDGRID_API_KEY) |
| testkube-cloud-api.api.smtp.host | string | `""` | SMTP host |
| testkube-cloud-api.api.smtp.password | string | `""` | SMTP password |
| testkube-cloud-api.api.smtp.passwordSecretRef | string | `""` | SMTP secret ref (secret must contain key SMTP_PASSWORD), overrides password field if defined |
| testkube-cloud-api.api.smtp.port | int | `587` | SMTP port |
| testkube-cloud-api.api.smtp.username | string | `""` | SMTP username |
| testkube-cloud-api.api.tls.certManager.issuerKind | string | `"ClusterIssuer"` | Certificate Issuer kind (only used if `provider` is set to `cert-manager`) |
| testkube-cloud-api.api.tls.tlsSecret | string | `"testkube-enterprise-api-tls"` |  |
| testkube-cloud-api.customCaDirPath | string | `""` | Specifies the path to the directory (skip the trailing slash) where CA certificates should be mounted. The mounted file should container a PEM encoded CA certificate. |
| testkube-cloud-api.enterpriseLicenseFilePath | string | `"/testkube/license.lic"` | Specifies the path where the license file should be mounted. |
| testkube-cloud-api.enterpriseLicenseKeyPath | string | `"/testkube/license.key"` | Specifies the path where the license key should be mounted. |
| testkube-cloud-api.fullnameOverride | string | `"testkube-enterprise-api"` |  |
| testkube-cloud-api.image.registry | string | `""` | If defined, it will prepend the registry to the image name, if not, default docker.io will be prepended |
| testkube-cloud-api.image.repository | string | `"kubeshop/testkube-enterprise-api"` |  |
| testkube-cloud-api.image.tag | string | `"1.10.53"` |  |
| testkube-cloud-api.ingress.className | string | `"nginx"` |  |
| testkube-cloud-api.init.enabled | bool | `false` | Toggle whether to enable the dependency check containers |
| testkube-cloud-api.init.mongo.image.pullPolicy | string | `"IfNotPresent"` | MongoSH image pull policy |
| testkube-cloud-api.init.mongo.image.repository | string | `"alpine/mongosh"` | MongoSH image repository |
| testkube-cloud-api.init.mongo.image.tag | string | `"2.0.2"` | MongoSH image tag |
| testkube-cloud-api.prometheus.enabled | bool | `false` |  |
| testkube-cloud-api.resources | object | `{"limits":{"cpu":1,"memory":"512Mi"},"requests":{"cpu":"50m","memory":"64Mi"}}` | Set resources requests and limits for Testkube Api |
| testkube-cloud-api.serviceAccount.annotations | object | `{}` | Additional annotations to add to the ServiceAccount resource |
| testkube-cloud-api.serviceAccount.create | bool | `false` | Toggle whether to create a ServiceAccount resource |
| testkube-cloud-api.serviceAccount.labels | object | `{}` | Additional labels to add to the ServiceAccount resource |
| testkube-cloud-api.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| testkube-cloud-api.testConnection.enabled | bool | `false` |  |
| testkube-cloud-ui.fullnameOverride | string | `"testkube-enterprise-ui"` |  |
| testkube-cloud-ui.image.registry | string | `""` | If defined, it will prepend the registry to the image name, if not, default docker.io will be prepended |
| testkube-cloud-ui.image.repository | string | `"kubeshop/testkube-enterprise-ui"` |  |
| testkube-cloud-ui.image.tag | string | `"2.2.1"` |  |
| testkube-cloud-ui.ingress.className | string | `"nginx"` | Ingress classname |
| testkube-cloud-ui.ingress.tlsSecretName | string | `"testkube-enterprise-ui-tls"` | Name of the TLS secret which contains the certificate files |
| testkube-cloud-ui.ingressRedirect | object | `{"enabled":false}` | Toggle whether to enable redirect Ingress which allows having a different subdomain redirecting to the actual Dashboard UI Ingress URL |
| testkube-cloud-ui.resources | object | `{"limits":{"cpu":"150m","memory":"128Mi"},"requests":{"cpu":"50m","memory":"64Mi"}}` | Set resources requests and limits for Testkube UI |
| testkube-cloud-ui.ui.authStrategy | string | `""` | Auth strategy to use (possible values: "" (default), "gitlab", "github"), setting to "" enables all auth strategies, if you use a custom Dex connector, set this to the id of the connector |
| testkube-worker-service.additionalEnv.USE_MINIO | bool | `true` |  |
| testkube-worker-service.api.minio.credsFilePath | string | `""` | Path to where a Minio credential file should be mounted |
| testkube-worker-service.api.mongo.allowDiskUse | bool | `false` | Allow or prohibit writing temporary files on disk when a pipeline stage exceeds the 100 megabyte limit. |
| testkube-worker-service.api.mongo.database | string | `"testkubeEnterpriseDB"` | Mongo database name |
| testkube-worker-service.api.mongo.dsn | string | `"mongodb://testkube-enterprise-mongodb:27017"` | Mongo DSN connection string |
| testkube-worker-service.api.mongo.dsnSecretRef | string | `""` | Mongo DSN connection string secret ref (secret must contain key MONGO_DSN) (default is `mongo-dsn`) |
| testkube-worker-service.api.mongo.readPreference | string | `"secondaryPreferred"` | Mongo read preference (primary|primaryPreferred|secondary|secondaryPreferred|nearest) |
| testkube-worker-service.api.nats.uri | string | `"nats://testkube-enterprise-nats:4222"` | NATS URI |
| testkube-worker-service.customCaDirPath | string | `""` | Specifies the path to the directory (skip the trailing slash) where CA certificates should be mounted. The mounted file should container a PEM encoded CA certificate. |
| testkube-worker-service.fullnameOverride | string | `"testkube-enterprise-worker-service"` |  |
| testkube-worker-service.image.registry | string | `""` | If defined, it will prepend the registry to the image name, if not, default docker.io will be prepended |
| testkube-worker-service.image.repository | string | `"kubeshop/testkube-enterprise-worker-service"` |  |
| testkube-worker-service.image.tag | string | `"1.10.41"` |  |
| testkube-worker-service.resources | object | `{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"75m","memory":"64Mi"}}` | Set resources requests and limits for Testkube Worker Service |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
