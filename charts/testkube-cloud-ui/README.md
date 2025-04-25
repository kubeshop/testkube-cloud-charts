# testkube-cloud-ui

![Version: 1.110.1](https://img.shields.io/badge/Version-1.110.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.12.3](https://img.shields.io/badge/AppVersion-2.12.3-informational?style=flat-square)

A Helm chart for Testkube Cloud UI

**Homepage:** <https://github.com/kubeshop/testkube-cloud-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| testkube |  | <https://testkube.io> |

## Source Code

* <https://github.com/kubeshop/testkube-cloud-ui>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalEnv.FEATURE_MULTI_AGENT | bool | `true` |  |
| affinity | object | `{}` |  |
| ai.aiServiceApiUri | string | `""` | Testkube AI service API URI |
| ai.enabled | bool | `false` | Enable Testkube AI features |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| externalSecrets.clusterSecretStoreName | string | `"secret-store"` |  |
| externalSecrets.enabled | bool | `false` |  |
| externalSecrets.keys | object | `{}` |  |
| externalSecrets.refreshInterval | string | `"5m"` |  |
| fullnameOverride | string | `""` |  |
| global.aiApiSubdomain | string | `"ai"` | AI API subdomain which get prepended to the domain |
| global.certManager.issuerRef | string | `""` | Certificate Issuer ref (only used if `provider` is set to `cert-manager`) |
| global.certificateProvider | string | `""` | TLS provider (possible values: "", "cert-manager") |
| global.containerSecurityContext | object | `{}` | Global security Context for all containers |
| global.domain | string | `""` | Domain under which to create Ingress rules |
| global.enterpriseMode | bool | `false` | Toggle whether UI is installed in Enterprise mode |
| global.imagePullSecrets | list | `[]` | Global image pull secrets (provided usually by a parent chart like testkube-enterprise) |
| global.imageRegistry | string | `""` | Global image registry to be prepended for to all images (usually defined in parent chart) |
| global.ingress.enabled | bool | `true` | Global toggle whether to create Ingress resources |
| global.labels | object | `{}` | Common labels which will be added to all resources |
| global.podDisruptionBudget | object | `{"enabled":false}` | Global PodDisruptionBudget |
| global.podSecurityContext | object | `{}` | Global security Context for all pods |
| global.redirectSubdomain | string | `"app"` | Different UI subdomain which gets prepended to the domain. May be used for the redirect from your actual uiSubdomain endpoint. Works is ingressRedirect option is enabled. |
| global.restApiSubdomain | string | `"api"` | REST API subdomain |
| global.uiSubdomain | string | `"cloud"` | UI subdomain which get prepended to the domain |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.registry | string | `""` | If defined, it will prepend the registry to the image name, if not, default docker.io will be prepended |
| image.repository | string | `"kubeshop/testkube-enterprise-ui"` |  |
| image.tag | string | `"2.12.3"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` | Additional Ingress annotations |
| ingress.className | string | `"nginx"` | Ingress class (NGINX Controller is the only officially supported Ingress controller) |
| ingress.enabled | bool | `true` | Toggle whether to create Ingress resource |
| ingress.host | string | `""` | Hostname for which to create rules and TLS certificates |
| ingress.labels | object | `{}` | Additional Ingress labels |
| ingress.tls.provider | string | `"cert-manager"` | TLS provider (possible values: "", "cert-manager") |
| ingress.tlsSecretName | string | `"testkube-cloud-ui-tls"` | Name of the TLS secret which contains the certificate files |
| ingressRedirect | object | `{"annotations":{},"enabled":false,"labels":{}}` | Toggle whether to enable redirect Ingress which allows having a different subdomain redirecting to the actual Dashboard UI Ingress URL |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podDisruptionBudget.enabled | bool | `false` | Enable a [pod distruption budget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) to help dealing with [disruptions](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/). |
| podDisruptionBudget.maxUnavailable | int/percentage | `""` | Number or percentage of pods that can be unavailable. |
| podDisruptionBudget.minAvailable | int/percentage | `""` | Number or percentage of pods that must remain available. |
| podSecurityContext | object | `{}` | Pod Security Context |
| priorityClassName | string | `""` | Priority class name defines the priority of this pod relative to others in the cluster. |
| replicaCount | int | `1` |  |
| resources.limits.cpu | string | `"150m"` |  |
| resources.limits.memory | string | `"128Mi"` |  |
| resources.requests.cpu | string | `"50m"` |  |
| resources.requests.memory | string | `"64Mi"` |  |
| securityContext | object | `{"readOnlyRootFilesystem":true}` | Container Security Context |
| sentry.enabled | bool | `false` | Toggle whether to enable Sentry.io error reporting |
| sentry.secretRef | string | `""` | Sentry.io secret ref (secret must contain key SENTRY_URL) (default is `testkube-cloud-sentry-secret`) |
| sentry.url | string | `""` | Sentry.io authenticated URL |
| service.port | int | `8080` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` | Additional annotations to add to the ServiceAccount resource |
| serviceAccount.create | bool | `false` | Toggle whether to create ServiceAccount resource |
| serviceAccount.labels | object | `{}` | Additional labels to add to the ServiceAccount resource |
| serviceAccount.name | string | `""` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| testConnection.enabled | bool | `false` |  |
| tolerations | list | `[]` |  |
| topologySpreadConstraints | list | `[]` | Topology spread constraints can be used to define how pods should be spread across failure domains within your cluster. |
| ui.apiServerEndpoint | string | `""` | API Server endpoint URL |
| ui.authStrategy | string | `""` | Auth strategy to use (possible values: "" (default), "gitlab", "github"), setting to "" enables all auth strategies |
| ui.disableTelemetry | bool | `false` | Force disabling telemetry on the UI |
| ui.rootRoute | string | `""` | The URL on which UI is served |
| ui.segment.secretRef | string | `""` | Segment.io write key secret ref (secret must contain key SEGMENTIO_WRITE_KEY_UI) (default is `testkube-cloud-analytics-secret`) |
| ui.segment.writeKey | string | `""` | Segment.io write key (overriden by `secretRef` if set) |
| ui.wsServerEndpoint | string | `""` | WebSocket Server endpoint URL |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
