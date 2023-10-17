# testkube-cloud-api

![Version: 1.15.74](https://img.shields.io/badge/Version-1.15.74-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.5.10](https://img.shields.io/badge/AppVersion-1.5.10-informational?style=flat-square)

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
| api.agent.hide | bool | `false` |  |
| api.agent.host | string | `""` | Agent host with protocol (example `agent.testkube.xyz`) |
| api.agent.port | string | `"443"` | Agent port |
| api.apiAddress | string | `""` | API address (used in invitation emails) (example `https://api.testkube.xyz`) |
| api.dashboardAddress | string | `""` | Dashboard address (used in invitation emails) (example `https://cloud.testkube.xyz`) |
| api.inviteMode | string | `"email"` | Configure which invitation mode to use (email|auto-accept): email uses SMTP protocol to send email invites and auto-accept immediately adds them |
| api.migrations.enabled | bool | `false` | Toggle whether to apply migrations for MongoDB |
| api.migrations.useHelmHooks | bool | `true` | Toggle whether to enable pre-install & pre-upgrade hooks |
| api.minio.accessKeyId | string | `""` | MinIO access key id |
| api.minio.credsSecretRef | string | `""` | Credentials secret ref (secret should contain keys: MINIO_ACCESS_KEY_ID, MINIO_SECRET_ACCESS_KEY, MINIO_TOKEN) (default is `testkube-cloud-minio-secret`) |
| api.minio.endpoint | string | `"minio.testkube.svc.cluster.local:9000"` | MinIO endpoint |
| api.minio.expirationPeriod | int | `0` | Expiration period in days |
| api.minio.region | string | `""` | S3 region |
| api.minio.secretAccessKey | string | `""` | MinIO secret access key |
| api.minio.secure | bool | `false` | Should be set to `true` if MinIO is behind |
| api.minio.token | string | `""` | MinIO token |
| api.mongo.database | string | `"testkubecloud"` | Mongo database name |
| api.mongo.dsn | string | `"mongodb://mongodb.testkube.svc.cluster.local:27017"` | if mongoDsnSecretRef is empty (""), mongoDsn field will be used for setting the Mongo DSN connection string |
| api.mongo.dsnSecretRef | string | `""` | Mongo DSN connection string secret ref (secret must contain key MONGO_DSN) (default is `mongo-dsn`) |
| api.nats.uri | string | `"nats://nats.messaging.svc.cluster.local:4222"` | NATS URI |
| api.oauth.allowedExternalRedirectURIs | string | `""` | Comma-separated list of allowed external redirect URIs (example: `https://cloud.testkube.xyz,http://localhost:3000`) |
| api.oauth.cliClientId | string | `""` | if oauth.secretRef is empty (""), then oauth.clientId field will be used for the OAuth cli client ID |
| api.oauth.clientId | string | `""` | if oauth.secretRef is empty (""), then oauth.clientId field will be used for the OAuth client ID |
| api.oauth.clientSecret | string | `""` | if oauth.secretRef is empty (""), then oauth.clientSecret field will be used for the OAuth client secret |
| api.oauth.issuerUrl | string | `""` | if oauth.secretRef is empty (""), then oauth.issuerUrl field will be used for the OAuth issuer URL |
| api.oauth.redirectUri | string | `""` | if oauth.secretRef is empty (""), then oauth.redirectUri field will be used for the OAuth redirect URI |
| api.oauth.secretRef | string | `""` | OAuth secret ref for OAuth configuration (secret must contain keys: OAUTH_CLIENT_ID, OAUTH_CLIENT_SECRET, OAUTH_ISSUER_URL, OAUTH_REDIRECT_URI) (default is `testkube-cloud-oauth-secret`) |
| api.outputsBucket | string | `"testkube-cloud-outputs"` | S3 bucket in which outputs are stored |
| api.sendgrid.apiKey | string | `""` | Sendgrid API key |
| api.sendgrid.secretRef | string | `""` | Secret API key secret ref (secret must contain key SENDGRID_API_KEY) (default is `sendgrid-api-key`) |
| api.smtp.host | string | `"smtp.sendgrid.net"` | SMTP host |
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
| externalSecrets.clusterSecretStoreName | string | `"secret-store"` |  |
| externalSecrets.enabled | bool | `false` |  |
| externalSecrets.keys | object | `{}` |  |
| externalSecrets.refreshInterval | string | `"5m"` |  |
| fullnameOverride | string | `""` |  |
| global.certManager.issuerRef | string | `""` | Certificate Issuer ref (only used if `provider` is set to `cert-manager`) |
| global.certificateProvider | string | `""` | TLS provider (possible values: "", "cert-manager") |
| global.dex.issuer | string | `""` | Global Dex issuer url |
| global.domain | string | `""` | Domain under which to create Ingress rules |
| global.enterpriseLicenseFile | string | `""` | Base64-encoded Enterprise License file |
| global.enterpriseLicenseKey | string | `""` | Enterprise License key |
| global.enterpriseLicenseSecretRef | string | `""` | Enterprise License file secret ref (secret should contain a file called 'license.lic') |
| global.enterpriseMode | bool | `false` | Toggle whether UI is installed in Enterprise mode |
| global.enterpriseOfflineAccess | bool | `false` | Toggle whether to enable offline license activation in Enterprise mode |
| global.grpcApiSubdomain | string | `"agent"` | gRPC API subdomain which get prepended to the domain |
| global.imagePullSecrets | list | `[]` | Global image pull secrets (provided usually by a parent chart like testkube-enterprise) |
| global.ingress.enabled | bool | `true` | Toggle whether to enable or disable all Ingress resources (if false, all Ingress resources will be disabled and cannot be overriden) |
| global.restApiSubdomain | string | `"api"` | REST API subdomain which get prepended to the domain |
| global.statusPagesApiSubdomain | string | `"status"` | Status Pages API subdomain which get prepended to the domain |
| global.uiSubdomain | string | `"cloud"` | UI subdomain which get prepended to the domain |
| global.websocketApiSubdomain | string | `"websockets"` | Websocket API subdomain which get prepended to the domain |
| grpcIngress.annotations | object | `{}` | Additional annotations to add to the gRPC Ingress resource |
| grpcIngress.enabled | bool | `true` | Toggle whether to enable the gRPC API Ingress |
| grpcIngress.host | string | `""` | Hostname for which to create rules and TLS certificates |
| grpcIngress.labels | object | `{}` | Additional labels to add to the gRPC Ingress resource |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"kubeshop/testkube-cloud-api"` |  |
| image.tag | string | `"1.0.0"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{"nginx.ingress.kubernetes.io/force-ssl-redirect":"true","nginx.ingress.kubernetes.io/preserve-trailing-slash":"true"}` | Common annotations which will be added to all Ingress resources |
| ingress.className | string | `"nginx"` | Common Ingress class name (NGINX is the only officially supported ingress controller and should not be changed) |
| minio.accessModes | list | `["ReadWriteOnce"]` | PVC Access Modes for Minio. The volume is mounted as read-write by a single node. |
| minio.affinity | object | `{}` | Affinity for pod assignment (note: podAffinityPreset, podAntiAffinityPreset, and nodeAffinityPreset will be ignored when it's set) |
| minio.credentials.accessKeyId | string | `""` | MinIO access key |
| minio.credentials.secretAccessKey | string | `""` | MinIO secret key |
| minio.credentials.secretRef | string | `""` | MinIO credentials secret ref (secret must contain keys ACCESS_KEY_ID and SECRET_ACCESS_KEY) |
| minio.customServiceAccountName | string | `""` | Custom service account to attach to the MinIO deployment |
| minio.enabled | bool | `false` | Toggle whether to deploy MinIO |
| minio.extraEnvVars | object | `{}` | Extra env vars to pass to MinIO deployment |
| minio.image.pullPolicy | string | `"IfNotPresent"` |  |
| minio.image.repository | string | `"minio/minio"` |  |
| minio.image.tag | string | `"RELEASE.2023-05-04T21-44-30Z"` |  |
| minio.nodeSelector | object | `{}` | Node labels for pod assignment. |
| minio.persistence.storage | string | `"10Gi"` | Size of the volume claim for MinIO data |
| minio.podSecurityContext | object | `{}` | MinIO Pod Security Context |
| minio.resources.limits | object | `{}` | It is strongly recommended to set limits for both cpu and memory |
| minio.resources.requests.cpu | string | `"100m"` |  |
| minio.resources.requests.memory | string | `"128Mi"` |  |
| minio.securityContext | object | `{}` | MinIO Container Security Context |
| minio.serviceAccount.annotations | object | `{}` | Additional annotations to add to the ServiceAccount resource |
| minio.serviceAccount.create | bool | `false` | Toggle whether to create a ServiceAccount resource |
| minio.serviceAccount.labels | object | `{}` | Additional labels to add to the ServiceAccount resource |
| minio.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| minio.tolerations | list | `[]` | Tolerations for pod assignment. |
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
| restIngress.host | string | `""` | Hostname for which to create rules and TLS certificates |
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
| statusPagesIngress.annotations | object | `{}` | Additional annotations to add to the WebSocket Ingress resource |
| statusPagesIngress.enabled | bool | `true` | Toggle whether to enable the Status Pages API Ingress |
| statusPagesIngress.host | string | `""` | Hostname for which to create rules and TLS certificates |
| statusPagesIngress.labels | object | `{}` | Additional labels to add to the WebSocket Ingress resource |
| testkube-cloud-api.image.tag | string | `"1.5.10"` |  |
| tolerations | list | `[]` |  |
| websocketsIngress.annotations | object | `{}` | Additional annotations to add to the WebSocket Ingress resource |
| websocketsIngress.enabled | bool | `true` | Toggle whether to enable the Websocket API Ingress |
| websocketsIngress.host | string | `""` | Hostname for which to create rules and TLS certificates |
| websocketsIngress.labels | object | `{}` | Additional labels to add to the WebSocket Ingress resource |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
