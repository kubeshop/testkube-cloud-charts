# testkube-ai-service

![Version: 1.17.1](https://img.shields.io/badge/Version-1.17.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.4.2](https://img.shields.io/badge/AppVersion-2.4.2-informational?style=flat-square)

A Helm chart for Testkube AI service

**Homepage:** <https://github.com/kubeshop/testkube-cloud-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| testkube |  | <https://testkube.io> |

## Source Code

* <https://github.com/kubeshop/testkube-ai>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalEnvVars | list | `[]` | Additional env vars to be added to the deployment, expects an array of EnvVar objects (supports name, value, valueFrom, etc.) |
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| controlPlaneRestApiUri | string | `""` | URI to Testkube's control plane REST API (e.g. https://api.testkube.io) |
| externalSecrets | object | `{"clusterSecretStoreName":"secret-store","enabled":false,"keys":{},"refreshInterval":"5m"}` | Retrieve secrets from external sources using [External Secrets Operator](https://external-secrets.io/) |
| externalSecrets.clusterSecretStoreName | string | `"secret-store"` | Cluster Secret Store name |
| externalSecrets.enabled | bool | `false` | Enable the use of external secrets |
| externalSecrets.keys | object | `{}` | Key/value secrets to be retrieved from the external secret store |
| externalSecrets.refreshInterval | string | `"5m"` | Refresh interval for external secrets |
| fullnameOverride | string | `""` |  |
| global.containerSecurityContext | object | `{}` | Global security Context for all containers |
| global.customCaSecretKey | string | `"ca.crt"` | Custom CA to use as a trusted CA during TLS connections. Specify a key for the secret specified under customCaSecretRef. |
| global.customCaSecretRef | string | `""` | Custom CA to use as a trusted CA during TLS connections. Specify a secret with the PEM encoded CA under the key specified by customCaSecretKey. |
| global.dex.issuer | string | `""` | Global Dex issuer url which is configured both in Dex and API |
| global.domain | string | `""` | Domain under which endpoints are exposed |
| global.imagePullSecrets | list | `[]` | Global image pull secrets (provided usually by a parent chart like testkube-enterprise) |
| global.imageRegistry | string | `""` | Global image registry to be prepended for to all images (usually defined in parent chart) |
| global.ingress.enabled | bool | `true` | Toggle whether to enable or disable all Ingress resources (if false, all Ingress resources will be disabled and cannot be overriden) |
| global.labels | object | `{}` | Common labels which will be added to all resources |
| global.podDisruptionBudget | object | `{"enabled":false}` | Global PodDisruptionBudget |
| global.podSecurityContext | object | `{}` | Global security Context for all pods |
| global.restApiSubdomain | string | `"api"` | REST API subdomain which get prepended to the domain |
| host | string | `""` | Hostname for which to create rules and TLS certificates (if omitted, the host will be generated using the global subdomain and `domain` values) |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.registry | string | `""` | If defined, it will prepend the registry to the image name, if not, default docker.io will be prepended |
| image.repository | string | `"kubeshop/testkube-ai-copilot"` |  |
| image.tag | string | `"2.4.2"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `"nginx"` |  |
| ingress.enabled | bool | `true` |  |
| llmApi | object | `{"apiKey":"","secretRef":"","secretRefKey":"","url":""}` | Configuration for LLM API that supports OpenAI API specification |
| llmApi.apiKey | string | `""` | API key for accessing the LLM service - can be provided directly or referenced from a secret |
| llmApi.secretRef | string | `""` | Reference to the secret containing the LLM API token |
| llmApi.secretRefKey | string | `""` | Reference to the secret key containing the LLM API token. |
| llmApi.url | string | `""` | Optional URL for custom LLM API services (defaults to OpenAI if not provided) |
| llmTracing | object | `{"apiKey":"","enabled":false,"secretRef":"","secretRefKey":""}` | Configuration for tracing and monitoring LLM operations in Testkube Cloud. Not required for enterprise/on-premises deployments. |
| llmTracing.apiKey | string | `""` | Can be provided directly or referenced from a secret. |
| llmTracing.enabled | bool | `false` | Toggle whether to enable or disable LLM tracing |
| llmTracing.secretRef | string | `""` | Reference to the secret containing the API Key. |
| llmTracing.secretRefKey | string | `""` | Reference to the secret key containing the API Key. |
| logLevel | string | `"info"` | Log level |
| nameOverride | string | `""` |  |
| nodeEnv | string | `"production"` | Environment of deployment |
| nodeSelector | object | `{}` |  |
| oidcDiscoveryUri | string | `""` | Use OpenID Conect (OIDC) Discovery endpoint to fetch configurations from the identity provider. The path should end with `/.well-known/openid-configuration`. |
| podAnnotations | object | `{}` |  |
| podDisruptionBudget.enabled | bool | `false` | Enable a [pod distruption budget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) to help dealing with [disruptions](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/). |
| podDisruptionBudget.maxUnavailable | int/percentage | `""` | Number or percentage of pods that can be unavailable. |
| podDisruptionBudget.minAvailable | int/percentage | `""` | Number or percentage of pods that must remain available. |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| priorityClassName | string | `""` | Priority class name defines the priority of this pod relative to others in the cluster. |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.annotations | object | `{}` | Additional annotations to add to the Service resource |
| service.labels | object | `{}` | Additional labels to add to the Service resource |
| service.port | int | `9090` | AI API port |
| service.type | string | `"ClusterIP"` | Service type |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tls.certManager.issuerGroup | string | `"cert-manager.io"` | Certificate Issuer group (only used if `provider` is set to `cert-manager`) |
| tls.certManager.issuerKind | string | `"ClusterIssuer"` | Certificate Issuer kind (only used if `provider` is set to `cert-manager`) |
| tls.certPath | string | `"/tmp/serving-cert/crt.pem"` | Mount path for the certificate |
| tls.keyPath | string | `"/tmp/serving-cert/key.pem"` | Mount path for the certificate private key |
| tls.serveHTTPS | bool | `true` | Toggle should the Application terminate TLS instead of the Ingress |
| tls.tlsSecret | string | `"testkube-ai-tls"` | TLS secret name which contains the certificate files |
| tolerations | list | `[]` |  |
| topologySpreadConstraints | list | `[]` | Topology spread constraints can be used to define how pods should be spread across failure domains within your cluster. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
