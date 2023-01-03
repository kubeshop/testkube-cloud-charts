# testkube-cloud-api

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.2.1](https://img.shields.io/badge/AppVersion-0.2.1-informational?style=flat-square)

A Helm chart for Testkube Cloud API

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| analytics.segmentio.secretRef | string | `"testkube-cloud-analytics-secret"` |  |
| analytics.segmentio.writeKey | string | `""` |  |
| api.agent.hide | bool | `false` |  |
| api.agent.host | string | `"localhost"` | Agent host (without protocol |
| api.agent.port | int | `8089` | Agent port |
| api.apiAddress | string | `"localhost:8088"` | API address (used in invitation emails) |
| api.dashboardAddress | string | `"localhost:3000"` | Dashboard address (used in invitation emails |
| api.mongoDb | string | `"testkubecloud"` | Mongo database name |
| api.mongoDsn | string | `"mongodb://mongodb.testkube.svc.cluster.local:27017"` | if mongoDsnSecretRef is empty (""), mongoDsn field will be used for setting the Mongo DSN connection string |
| api.mongoDsnSecretRef | string | `"mongo-dsn"` | Mongo DSN connection string secret ref (secret must contain key MONGO_DSN) |
| api.natsUri | string | `"nats://nats.messaging.svc.cluster.local:4222"` | NATS URI |
| api.oauth.allowedExternalRedirectURIs | string | `"https://cloud.testkube.xyz"` | Comma-separated list of allowed external redirect URIs |
| api.oauth.clientId | string | `""` | if oauth.secretRef is empty (""), then oauth.clientId field will be used for the OAuth client ID |
| api.oauth.clientSecret | string | `""` | if oauth.secretRef is empty (""), then oauth.clientSecret field will be used for the OAuth client secret |
| api.oauth.issuerUrl | string | `""` | if oauth.secretRef is empty (""), then oauth.issuerUrl field will be used for the OAuth issuer URL |
| api.oauth.redirectUri | string | `""` | if oauth.secretRef is empty (""), then oauth.redirectUri field will be used for the OAuth redirect URI |
| api.oauth.secretRef | string | `""` | OAuth secret ref for OAuth configuration (secret must contain keys: OAUTH_CLIENT_ID, OAUTH_CLIENT_SECRET, OAUTH_ISSUER_URL, OAUTH_REDIRECT_URI) |
| api.sendgrid.apiKey | string | `""` | Sendgrid API key |
| api.sendgrid.secretRef | string | `""` | Name of secret which contains SENDGRID_API_KEY key |
| api.tls.agentPort | int | `8443` | Agent gRPCS port |
| api.tls.apiPort | int | `9443` | API HTTPS port |
| api.tls.certPath | string | `"/tmp/serving-cert/crt.pem"` | certificate path |
| api.tls.domains | list | `[]` | certificate domains |
| api.tls.enabled | bool | `false` | Toggle whether to handle TLS in API |
| api.tls.issuerRef | string | `"letsencrypt-dev"` | cert-manager ClusterIssuer ref |
| api.tls.keyPath | string | `"/tmp/serving-cert/key.pem"` | certificate key path |
| api.tls.tlsSecret | string | `"testkube-cloud-api-tls"` | tls secret name which ClusterIssuer will use to store certificate data |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| fullnameOverride | string | `""` |  |
| grpcIngress.annotations | object | `{}` |  |
| grpcIngress.className | string | `"nginx"` |  |
| grpcIngress.enabled | bool | `false` |  |
| grpcIngress.hosts | list | `[]` |  |
| grpcIngress.labels."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| grpcIngress.tls | list | `[]` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"kubeshop/testkube-cloud-api"` |  |
| image.tag | string | `"0.2.1"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `"nginx"` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts | list | `[]` |  |
| ingress.labels."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| prometheus.enabled | bool | `false` |  |
| prometheus.labels | object | `{}` |  |
| prometheus.path | string | `"/metrics"` |  |
| prometheus.port | string | `"metrics"` |  |
| prometheus.scrapeInterval | string | `"15s"` |  |
| replicaCount | int | `1` |  |
| resources.limits.cpu | string | `"100m"` |  |
| resources.limits.memory | string | `"128Mi"` |  |
| resources.requests.cpu | string | `"300m"` |  |
| resources.requests.memory | string | `"320Mi"` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| service.grpcPort | int | `8089` |  |
| service.metricsPort | int | `9000` |  |
| service.port | int | `8088` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
