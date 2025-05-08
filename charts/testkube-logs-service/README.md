# testkube-logs-service

![Version: 1.35.2](https://img.shields.io/badge/Version-1.35.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.12.1](https://img.shields.io/badge/AppVersion-1.12.1-informational?style=flat-square)

A Helm chart for Testkube log Service

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
| api.minio.accessKeyId | string | `""` | MinIO access key id |
| api.minio.credsFilePath | string | `""` | Path to where a Minio credential file should be mounted |
| api.minio.credsSecretRef | string | `""` | Credentials secret ref (secret should contain keys: root-user, root-password, token) (default is `testkube-cloud-minio-secret`) |
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
| api.outputsBucket | string | `"testkube-cloud-outputs"` | S3 bucket in which outputs are stored |
| api.tls.agentPort | int | `8443` | Agent gRPCS port |
| api.tls.apiPort | int | `9443` | API HTTPS port |
| api.tls.certManager.issuerGroup | string | `"cert-manager.io"` | Certificate Issuer group (only used if `provider` is set to `cert-manager`) |
| api.tls.certManager.issuerKind | string | `"ClusterIssuer"` | Certificate Issuer kind (only used if `provider` is set to `cert-manager`) |
| api.tls.certPath | string | `"/tmp/serving-cert/crt.pem"` | certificate path |
| api.tls.keyPath | string | `"/tmp/serving-cert/key.pem"` | certificate key path |
| api.tls.serveHTTPS | bool | `false` | Toggle should the Application terminate TLS instead of the Ingress |
| api.tls.tlsSecret | string | `"testkube-cloud-api-tls"` |  |
| autoscaling.enabled | bool | `false` | Toggle whether to enable Horizontal Pod Autoscaler |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| externalSecrets.clusterSecretStoreName | string | `"secret-store"` |  |
| externalSecrets.enabled | bool | `false` |  |
| externalSecrets.keys | object | `{}` |  |
| externalSecrets.refreshInterval | string | `"5m"` |  |
| fullnameOverride | string | `"logs-service"` |  |
| global.certManager.issuerRef | string | `""` | Certificate Issuer ref (only used if `provider` is set to `cert-manager`) |
| global.certificateProvider | string | `""` | TLS provider (possible values: "", "cert-manager") |
| global.containerSecurityContext | object | `{}` | Global security Context for all containers |
| global.domain | string | `""` | Domain under which to create Ingress rules |
| global.imagePullSecrets | list | `[]` | Global image pull secrets (provided usually by a parent chart like testkube-enterprise) |
| global.ingress.enabled | bool | `true` | Toggle whether to enable or disable all Ingress resources (if false, all Ingress resources will be disabled and cannot be overriden) |
| global.labels | object | `{}` | Common labels which will be added to all resources |
| global.logsSubdomain | string | `"logs"` | logs gRPC subdomain which get prepended to the default domain when host is not set |
| global.podDisruptionBudget | object | `{"enabled":false}` | Global PodDisruptionBudget |
| global.podSecurityContext | object | `{}` | Global security Context for all pods |
| grpcIngress.annotations | object | `{}` | Additional annotations to add to the gRPC Ingress resource |
| grpcIngress.enabled | bool | `false` | Toggle whether to enable the gRPC API Ingress |
| grpcIngress.host | string | `""` | Hostname for which to create rules and TLS certificates (if omitted, the host will be generated using the global subdomain and `domain` values) |
| grpcIngress.labels | object | `{}` | Additional labels to add to the gRPC Ingress resource |
| grpcIngress.maxPayloadSize | string | `"16m"` | Max payload size for proxied gRPC API |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"kubeshop/testkube-log-service"` |  |
| image.tag | string | `"1.6.7"` |  |
| image.tagSuffix | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{"nginx.ingress.kubernetes.io/force-ssl-redirect":"true","nginx.ingress.kubernetes.io/preserve-trailing-slash":"true"}` | Common annotations which will be added to all Ingress resources |
| ingress.className | string | `"nginx"` | Common Ingress class name (NGINX is the only officially supported ingress controller and should not be changed) |
| ingress.tlsSecretName | string | `"testkube-logs-service-api-tls"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podDisruptionBudget.enabled | bool | `false` | Enable a [pod distruption budget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) to help dealing with [disruptions](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/). |
| podDisruptionBudget.maxUnavailable | int/percentage | `""` | Number or percentage of pods that can be unavailable. |
| podDisruptionBudget.minAvailable | int/percentage | `""` | Number or percentage of pods that must remain available. |
| podSecurityContext | object | `{}` | Pod Security Context |
| prometheus.enabled | bool | `false` | Toggle whether to create ServiceMonitor resource for Prometheus Operator |
| prometheus.labels | object | `{}` | ServiceMonitor labels |
| prometheus.path | string | `"/metrics"` | Metrics path which will be scraped |
| prometheus.port | string | `"metrics"` | Metrics port which will be scraper |
| prometheus.scrapeInterval | string | `"15s"` | Scrape interval configuration in ServiceMonitor resource |
| replicaCount | int | `1` |  |
| resources.limits | object | `{}` | It is strongly recommended to set limits for both cpu and memory |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| securityContext | object | `{"readOnlyRootFilesystem":true}` | Security Context for app container |
| service.annotations | object | `{}` | Additional annotations to add to the Service resource |
| service.grpcPort | int | `8089` | GRPC service port (when TLS disabled) |
| service.labels | object | `{}` | Additional labels to add to the Service resource |
| service.metricsPort | int | `9100` | Metrics port |
| service.type | string | `"ClusterIP"` | Service type |
| serviceAccount.annotations | object | `{}` | Additional annotations to add to the ServiceAccount resource |
| serviceAccount.create | bool | `false` | Toggle whether to create a ServiceAccount resource |
| serviceAccount.labels | object | `{}` | Additional labels to add to the ServiceAccount resource |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
