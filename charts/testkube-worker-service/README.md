# testkube-worker-service

![Version: 1.79.0](https://img.shields.io/badge/Version-1.79.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.12.1](https://img.shields.io/badge/AppVersion-1.12.1-informational?style=flat-square)

A Helm chart for Testkube Worker Service

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
| api.minio.secure | bool | `false` | Should be set to `true` if MinIO is deployed with a TLS certificate in front. |
| api.minio.skipVerify | bool | `false` | Toggle whether to verify TLS certificates |
| api.minio.token | string | `""` | MinIO token |
| api.mongo.database | string | `"testkubecloud"` | Mongo database name |
| api.mongo.dsn | string | `"mongodb://mongodb.testkube.svc.cluster.local:27017"` | if mongoDsnSecretRef is empty (""), mongoDsn field will be used for setting the Mongo DSN connection string |
| api.mongo.dsnSecretRef | string | `""` | Mongo DSN connection string secret ref (secret must contain key MONGO_DSN) (default is `mongo-dsn`) |
| api.mongo.readPreference | string | `"secondaryPreferred"` | Mongo read preference (primary|primaryPreferred|secondary|secondaryPreferred|nearest) |
| api.nats.uri | string | `"nats://nats.messaging.svc.cluster.local:4222"` | NATS URI |
| api.outputsBucket | string | `"testkube-cloud-outputs"` | S3 bucket in which outputs are stored |
| autoscaling.enabled | bool | `false` | Toggle whether to enable Horizontal Pod Autoscaler |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| customCaDirPath | string | `""` | Specifies the path to the directory (skip the trailing slash) where CA certificates should be mounted. The mounted file should container a PEM encoded CA certificate. |
| externalSecrets.clusterSecretStoreName | string | `"secret-store"` |  |
| externalSecrets.enabled | bool | `false` |  |
| externalSecrets.keys | object | `{}` |  |
| externalSecrets.refreshInterval | string | `"5m"` |  |
| fullnameOverride | string | `""` |  |
| global.containerSecurityContext | object | `{}` | Global security Context for all containers |
| global.customCaSecretKey | string | `"ca.crt"` | Custom CA to use as a trusted CA during TLS connections. Specify a key for the secret specified under customCaSecretRef. |
| global.customCaSecretRef | string | `""` | Custom CA to use as a trusted CA during TLS connections. Specify a secret with the PEM encoded CA under the key specified by customCaSecretKey. |
| global.imagePullPolicy | string | `""` | Image pull policy |
| global.imagePullSecrets | list | `[]` | Image pull secrets |
| global.imageRegistry | string | `""` | Global image registry to be prepended for to all images (usually defined in parent chart) |
| global.labels | object | `{}` | Common labels which will be added to all resources |
| global.mongo.allowDiskUse | bool | `false` | Allow or prohibit writing temporary files on disk when a pipeline stage exceeds the 100 megabyte limit. |
| global.mongo.database | string | `""` | Mongo database name |
| global.mongo.dsn | string | `""` | Mongo DSN connection string |
| global.mongo.dsnSecretRef | string | `""` | Mongo DSN connection string secret ref (secret must contain key MONGO_DSN) (default is `mongo-dsn`) |
| global.mongo.readPreference | string | `""` | Mongo read preference (primary|primaryPreferred|secondary|secondaryPreferred|nearest) |
| global.nats.uri | string | `""` | NATS URI |
| global.podDisruptionBudget | object | `{"enabled":false}` | Global PodDisruptionBudget |
| global.podSecurityContext | object | `{}` | Global security Context for all pods |
| global.storage.accessKeyId | string | `""` | S3 Access Key ID |
| global.storage.credsSecretRef | string | `""` | Credentials secret ref (secret should contain keys: root-user, root-password, token) (default is `testkube-cloud-minio-secret`) |
| global.storage.endpoint | string | `""` | Endpoint to a S3 compatible storage service (without protocol) |
| global.storage.outputsBucket | string | `""` | S3 bucket in which Test Artifacts & Logs will be stored |
| global.storage.region | string | `""` | S3 region |
| global.storage.secretAccessKey | string | `""` | S3 Secret Access Key |
| global.storage.secure | string | `nil` | Toggle whether to use HTTPS when connecting to the S3 server |
| global.storage.skipVerify | string | `nil` | Toggle whether to skip verifying TLS certificates |
| global.storage.token | string | `""` | S3 Token |
| global.tls | object | `{}` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.registry | string | `""` | If defined, it will prepend the registry to the image name, if not, default docker.io will be prepended |
| image.repository | string | `"kubeshop/testkube-enterprise-worker-service"` |  |
| image.tag | string | `"1.12.1"` |  |
| image.tagSuffix | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podDisruptionBudget.enabled | bool | `false` | Enable a [pod distruption budget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) to help dealing with [disruptions](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/). |
| podDisruptionBudget.maxUnavailable | int/percentage | `""` | Number or percentage of pods that can be unavailable. |
| podDisruptionBudget.minAvailable | int/percentage | `""` | Number or percentage of pods that must remain available. |
| podSecurityContext | object | `{}` | Pod Security Context |
| priorityClassName | string | `""` | Priority class name defines the priority of this pod relative to others in the cluster. |
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
| service.labels | object | `{}` | Additional labels to add to the Service resource |
| service.metricsPort | int | `9000` | Metrics port |
| service.type | string | `"ClusterIP"` | Service type |
| serviceAccount.annotations | object | `{}` | Additional annotations to add to the ServiceAccount resource |
| serviceAccount.create | bool | `false` | Toggle whether to create a ServiceAccount resource |
| serviceAccount.labels | object | `{}` | Additional labels to add to the ServiceAccount resource |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
