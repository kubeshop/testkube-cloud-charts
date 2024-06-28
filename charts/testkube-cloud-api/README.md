# testkube-cloud-api

![Version: 1.62.3](https://img.shields.io/badge/Version-1.62.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.10.27](https://img.shields.io/badge/AppVersion-1.10.27-informational?style=flat-square)

A Helm chart for Testkube Cloud API

**Homepage:** <https://github.com/kubeshop/testkube-cloud-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| testkube |  | <https://testkube.io> |

## Source Code

* <https://github.com/kubeshop/testkube-cloud-api>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalEnv | object | `{}` | Additional env vars to be added to the deployment |
| affinity | object | `{}` |  |
| ai.apiKey | string | `""` | or use api key instead two above |
| ai.secretKey | string | `"key"` |  |
| ai.secretRef | string | `"openai-api-key"` | AI config secret ref |
| analytics.hubspot.apiKey | string | `""` | HubSpot write key |
| analytics.hubspot.enabled | bool | `false` | Toggle whether to enable HubSpot sync |
| analytics.hubspot.secretRef | string | `""` | HubSpot secret ref (secret must contain key HUBSPOT_API_KEY) (default is `testkube-cloud-analytics-secret`) |
| analytics.segmentio.enabled | bool | `false` | Toggle whether to enable Segment.io analytics |
| analytics.segmentio.secretRef | string | `""` | Segment.io secret ref (secret must contain key SEGMENTIO_WRITE_KEY) (default is `testkube-cloud-analytics-secret`) |
| analytics.segmentio.writeKey | string | `""` | Segment.io write key |
| api.agent.healthcheck.lock | string | `"kv"` | Agent healthcheck distributed mode (one of mongo|kv) - used for pods sync to run healthchecks on single pod at once |
| api.agent.hide | bool | `false` |  |
| api.agent.host | string | `""` | Agent host with protocol (example `agent.testkube.xyz`) |
| api.agent.keepAlive | bool | `false` | Toggle whether to enable agent grpc keepalive pings |
| api.agent.port | string | `"443"` | Agent port |
| api.apiAddress | string | `""` | API address (used in invitation emails) (example `https://api.testkube.xyz`) |
| api.dashboardAddress | string | `""` | Dashboard address (used in invitation emails) (example `https://cloud.testkube.xyz`) |
| api.debug.enableGrpcServerLogs | bool | `false` | Toggle whether to enable gRPC server logs |
| api.debug.enableHttp2Logs | bool | `false` | Toggle whether to enable debug logs by setting the GODEBUG=http2debug=2 |
| api.email.fromEmail | string | `""` | Email to use for sending outgoing emails |
| api.email.fromName | string | `""` | Name to use for sending outgoing emails |
| api.features.bootstrapConfig.config | object | `{}` |  |
| api.features.bootstrapConfig.enabled | bool | `false` |  |
| api.features.disablePersonalOrgs | bool | `false` | Toggle whether to disable personal organizations when a user signs up for the first time |
| api.features.legacyTests | bool | `false` | Toggle whether to enable support for legacy tests (Test, TestSuite) |
| api.inviteMode | string | `"auto-accept"` | Configure which invitation mode to use (email|auto-accept): email uses SMTP protocol to send email invites and auto-accept immediately adds them |
| api.logServer | object | `{"caFile":"","certFile":"","enabled":false,"grpcAddress":"testkube-logs-service:8089","host":"","keyFile":"","port":"443","secure":"false","skipVerify":"true"}` | External log server connection configuration |
| api.logServer.caFile | string | `""` | TLS CA certificate file |
| api.logServer.certFile | string | `""` | TLS certificate file |
| api.logServer.enabled | bool | `false` | Toggle whether to enable external log server connection |
| api.logServer.grpcAddress | string | `"testkube-logs-service:8089"` | Log server address for internal communication |
| api.logServer.host | string | `""` | Log server address for external communication (example `logs.testkube.xyz`) |
| api.logServer.keyFile | string | `""` | TLS key file |
| api.logServer.port | string | `"443"` | Log server port for external communication |
| api.logServer.secure | string | `"false"` | Log server TLS configuration secure connection |
| api.logServer.skipVerify | string | `"true"` | Log server TLS configuration skip Verify |
| api.migrations.enabled | bool | `false` | Toggle whether to apply migrations for MongoDB |
| api.migrations.ttlSecondsAfterFinished | int | `90` | TTL for the migration job |
| api.migrations.useHelmHooks | bool | `true` | Toggle whether to enable pre-install & pre-upgrade hooks |
| api.minio.accessKeyId | string | `""` | MinIO access key id |
| api.minio.certSecret.baseMountPath | string | `"/etc/client-certs/storage"` | Base path to mount the client certificate secret |
| api.minio.certSecret.caFile | string | `"ca.crt"` | Path to ca file (used for self-signed certificates) |
| api.minio.certSecret.certFile | string | `"cert.crt"` | Path to client certificate file |
| api.minio.certSecret.enabled | bool | `false` | Toggle whether to mount k8s secret which contains storage client certificate (cert.crt, cert.key, ca.crt) |
| api.minio.certSecret.keyFile | string | `"cert.key"` | Path to client certificate key file |
| api.minio.certSecret.name | string | `"storage-client-cert"` | Name of the storage client certificate secret |
| api.minio.credsSecretRef | string | `""` | Credentials secret ref (secret should contain keys: root-user, root-password, token) (default is `testkube-cloud-minio-secret`) |
| api.minio.endpoint | string | `"minio.testkube.svc.cluster.local:9000"` | MinIO endpoint |
| api.minio.expirationPeriod | int | `0` | Expiration period in days |
| api.minio.mountCACertificate | bool | `false` | If enabled, will also require a CA certificate to be provided |
| api.minio.region | string | `""` | S3 region |
| api.minio.secretAccessKey | string | `""` | MinIO secret access key |
| api.minio.secure | bool | `false` | Should be set to `true` if MinIO is behind |
| api.minio.signing.hostname | string | `""` | Hostname for the presigned PUT URL |
| api.minio.signing.secure | bool | `false` | Toggle should the presigned URL use HTTPS |
| api.minio.skipVerify | bool | `false` | Toggle whether to verify TLS certificates |
| api.minio.token | string | `""` | MinIO token |
| api.mongo.database | string | `"testkubecloud"` | Mongo database name |
| api.mongo.dsn | string | `"mongodb://mongodb.testkube.svc.cluster.local:27017"` | if mongoDsnSecretRef is empty (""), mongoDsn field will be used for setting the Mongo DSN connection string |
| api.mongo.dsnSecretRef | string | `""` | Mongo DSN connection string secret ref (secret must contain key MONGO_DSN) (default is `mongo-dsn`) |
| api.mongo.readPreference | string | `"secondaryPreferred"` | Mongo read preference (primary|primaryPreferred|secondary|secondaryPreferred|nearest) |
| api.nats.uri | string | `"nats://nats.messaging.svc.cluster.local:4222"` | NATS URI |
| api.oauth.allowedExternalRedirectURIs | string | `""` | Comma-separated list of allowed external redirect URIs (example: `https://cloud.testkube.xyz,http://localhost:3000`) |
| api.oauth.cliClientId | string | `""` | if oauth.secretRef is empty (""), then oauth.clientId field will be used for the OAuth cli client ID |
| api.oauth.clientId | string | `""` | if oauth.secretRef is empty (""), then oauth.clientId field will be used for the OAuth client ID |
| api.oauth.clientSecret | string | `""` | if oauth.secretRef is empty (""), then oauth.clientSecret field will be used for the OAuth client secret |
| api.oauth.issuerUrl | string | `""` | if oauth.secretRef is empty (""), then oauth.issuerUrl field will be used for the OAuth issuer URL |
| api.oauth.redirectUri | string | `""` | if oauth.secretRef is empty (""), then oauth.redirectUri field will be used for the OAuth redirect URI |
| api.oauth.secretRef | string | `""` | OAuth secret ref for OAuth configuration (secret must contain keys: OAUTH_CLIENT_ID, OAUTH_CLIENT_SECRET, OAUTH_ISSUER_URL, OAUTH_REDIRECT_URI) (default is `testkube-cloud-oauth-secret`) |
| api.outputsBucket | string | `"testkube-cloud-outputs"` | S3 bucket in which outputs are stored |
| api.redirectSubdomain | string | `""` | Different UI subdomain which gets prepended to the domain. May be used for the redirect from your actual uiSubdomain endpoint. Works is ingressRedirect option is enabled. |
| api.sendgrid.apiKey | string | `""` | Sendgrid API key |
| api.sendgrid.secretRef | string | `""` | Secret API key secret ref (secret must contain key SENDGRID_API_KEY) |
| api.smtp.host | string | `""` | SMTP host |
| api.smtp.password | string | `""` | SMTP password |
| api.smtp.passwordSecretRef | string | `""` | SMTP secret ref (secret must contain key SMTP_PASSWORD), overrides password field if defined |
| api.smtp.port | int | `587` | SMTP port |
| api.smtp.username | string | `""` | SMTP username |
| api.tls.agentPort | int | `8443` | Agent gRPCS port |
| api.tls.apiPort | int | `9443` | API HTTPS port |
| api.tls.certManager.issuerGroup | string | `"cert-manager.io"` | Certificate Issuer group (only used if `provider` is set to `cert-manager`) |
| api.tls.certManager.issuerKind | string | `"ClusterIssuer"` | Certificate Issuer kind (only used if `provider` is set to `cert-manager`) |
| api.tls.certPath | string | `"/tmp/serving-cert/crt.pem"` | certificate path |
| api.tls.keyPath | string | `"/tmp/serving-cert/key.pem"` | certificate key path |
| api.tls.serveHTTPS | bool | `true` | Toggle should the Application terminate TLS instead of the Ingress |
| api.tls.tlsSecret | string | `"testkube-cloud-api-tls"` | TLS secret name which contains the certificate files |
| autoscaling.enabled | bool | `false` | Toggle whether to enable Horizontal Pod Autoscaler |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| demoOrganizationId | string | `""` | Api can allow to set demo organization id where user who don't have Kubernetes cluster can play around |
| externalSecrets.clusterSecretStoreName | string | `"secret-store"` |  |
| externalSecrets.enabled | bool | `false` |  |
| externalSecrets.keys | object | `{}` |  |
| externalSecrets.refreshInterval | string | `"5m"` |  |
| fullnameOverride | string | `""` |  |
| global.certManager.issuerRef | string | `""` | Certificate Issuer ref (only used if `provider` is set to `cert-manager`) |
| global.certificateProvider | string | `""` | TLS provider (possible values: "", "cert-manager") |
| global.customCaSecretRef | string | `""` | Custom CA to use as a trusted CA during TLS connections. Specify a secret with the PEM encoded CA under the ca.crt key. |
| global.dex.issuer | string | `""` | Global Dex issuer url |
| global.domain | string | `""` | Domain under which endpoints are exposed |
| global.enterpriseLicenseFile | string | `""` | This field is deprecated. To specify an offline license file use `enterpriseLicenseSecretRef`. |
| global.enterpriseLicenseKey | string | `""` | Specifies the enterprise license key, when using an offline license use `enterpriseLicenseSecretRef` and leave this field empty. |
| global.enterpriseLicenseSecretRef | string | `""` | Enterprise license file secret reference. Place the license key under the key `LICENSE_KEY` key in the secret, and in case of an offline license place the license file under the key `license.lic` in the same secret. Make sure that the license key file does not have any new line characters at the end of the file. |
| global.enterpriseMode | bool | `false` | Toggle whether UI is installed in Enterprise mode |
| global.enterpriseOfflineAccess | bool | `false` | Toggle whether to enable offline license activation in Enterprise mode |
| global.grpcApiSubdomain | string | `"agent"` | gRPC API subdomain which get prepended to the domain |
| global.grpcLogsSubdomain | string | `"logs"` | gRPC Logs subdomain which get prepended to the domain |
| global.imagePullSecrets | list | `[]` | Global image pull secrets (provided usually by a parent chart like testkube-enterprise) |
| global.ingress.enabled | bool | `true` | Toggle whether to enable or disable all Ingress resources (if false, all Ingress resources will be disabled and cannot be overriden) |
| global.labels | object | `{}` | Common labels which will be added to all resources |
| global.mongo.allowDiskUse | bool | `false` | Allow or prohibit writing temporary files on disk when a pipeline stage exceeds the 100 megabyte limit. |
| global.mongo.database | string | `""` | Mongo database name |
| global.mongo.dsn | string | `""` | Mongo DSN connection string |
| global.mongo.dsnSecretRef | string | `""` | Mongo DSN connection string secret ref (secret must contain key MONGO_DSN) (default is `mongo-dsn`) |
| global.mongo.readPreference | string | `""` | Mongo read preference (primary|primaryPreferred|secondary|secondaryPreferred|nearest) |
| global.nats.uri | string | `""` | NATS URI |
| global.restApiSubdomain | string | `"api"` | REST API subdomain which get prepended to the domain |
| global.storage.accessKeyId | string | `""` | S3 Access Key ID |
| global.storage.credsSecretRef | string | `""` | Credentials secret ref (secret should contain keys: root-user, root-password, token) (default is `testkube-cloud-minio-secret`) |
| global.storage.endpoint | string | `""` | Endpoint to a S3 compatible storage service (without protocol) |
| global.storage.outputsBucket | string | `""` | S3 bucket in which Test Artifacts & Logs will be stored |
| global.storage.region | string | `""` | S3 region |
| global.storage.secretAccessKey | string | `""` | S3 Secret Access Key |
| global.storage.secure | string | `nil` | Toggle whether to use HTTPS when connecting to the S3 server |
| global.storage.skipVerify | string | `nil` | Toggle whether to skip verifying TLS certificates |
| global.storage.token | string | `""` | S3 Token |
| global.storageApiSubdomain | string | `"storage"` | Storage API subdomain which get prepended to the domain |
| global.uiSubdomain | string | `"cloud"` | UI subdomain which get prepended to the domain |
| global.websocketApiSubdomain | string | `"websockets"` | Websocket API subdomain which get prepended to the domain |
| grpcIngress.annotations | object | `{}` | Additional annotations to add to the gRPC Ingress resource |
| grpcIngress.enabled | bool | `true` | Toggle whether to enable the gRPC API Ingress |
| grpcIngress.host | string | `""` | Hostname for which to create rules and TLS certificates (if omitted, the host will be generated using the global subdomain and `domain` values) |
| grpcIngress.labels | object | `{}` | Additional labels to add to the gRPC Ingress resource |
| grpcIngress.maxPayloadSize | string | `"16m"` | Max payload size for proxied gRPC API |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"kubeshop/testkube-cloud-api"` |  |
| image.tag | string | `"1.10.27"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.className | string | `"nginx"` | Common Ingress class name (NGINX is the only officially supported ingress controller and should not be changed) |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| payments.apiKey | string | `""` | Payments API key (currently only Stripe is supported) |
| payments.enabled | bool | `false` | Toggle whether to enable payments service |
| payments.endpointSecret | string | `""` | Payments endpoint secret (currently only Stripe is supported) |
| payments.portalConfigurationId | string | `""` | Payments portal configuration ID (currently only Stripe is supported) |
| payments.secretRef | string | `""` | Payments config secret ref (secret must contain keys: PAYMENTS_PORTAL_CONFIGURATION_ID, PAYMENTS_ENDPOINT_SECRET and PAYMENTS_API_KEY) (default is `testkube-cloud-payments-secret`) |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` | Pod Security Context |
| prometheus.enabled | bool | `true` | Toggle whether to create ServiceMonitor resource for Prometheus Operator |
| prometheus.labels | object | `{}` | ServiceMonitor labels |
| prometheus.path | string | `"/metrics"` | Metrics path which will be scraped |
| prometheus.port | string | `"metrics"` | Metrics port which will be scraper |
| prometheus.scrapeInterval | string | `"15s"` | Scrape interval configuration in ServiceMonitor resource |
| replicaCount | int | `1` |  |
| resources.limits | object | `{}` | It is strongly recommended to set limits for both cpu and memory |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| restIngress.annotations | object | `{}` | Additional annotations to add to the REST Ingress resource |
| restIngress.enabled | bool | `true` | Toggle whether to enable the REST API Ingress |
| restIngress.host | string | `""` | Hostname for which to create rules and TLS certificates (if omitted, the host will be generated using the global subdomain and `domain` values) |
| restIngress.labels | object | `{}` | Additional labels to add to the REST Ingress resource |
| securityContext | object | `{"readOnlyRootFilesystem":true}` | Security Context for app container |
| service.annotations | object | `{}` | Additional annotations to add to the Service resource |
| service.grpcPort | int | `8089` | gRPC/Agent API port |
| service.labels | object | `{}` | Additional labels to add to the Service resource |
| service.metricsPort | int | `9000` | Metrics port |
| service.port | int | `8088` | REST API port |
| service.type | string | `"ClusterIP"` | Service type |
| serviceAccount.annotations | object | `{}` | Additional annotations to add to the ServiceAccount resource |
| serviceAccount.create | bool | `false` | Toggle whether to create a ServiceAccount resource |
| serviceAccount.labels | object | `{}` | Additional labels to add to the ServiceAccount resource |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| testConnection.enabled | bool | `false` |  |
| tolerations | list | `[]` |  |
| websocketsIngress.annotations | object | `{}` | Additional annotations to add to the WebSocket Ingress resource |
| websocketsIngress.enabled | bool | `true` | Toggle whether to enable the Websocket API Ingress |
| websocketsIngress.host | string | `""` | Hostname for which to create rules and TLS certificates (if omitted, the host will be generated using the global subdomain and `domain` values) |
| websocketsIngress.labels | object | `{}` | Additional labels to add to the WebSocket Ingress resource |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
