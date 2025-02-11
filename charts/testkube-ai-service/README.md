# testkube-ai-service

![Version: 1.0.3](https://img.shields.io/badge/Version-1.0.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.10.1](https://img.shields.io/badge/AppVersion-2.10.1-informational?style=flat-square)

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
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| controlPlaneRestApiUri | string | `""` | URI to Testkube's control plane REST API (e.g. https://api.testkube.io) |
| env | string | `"production"` | Environment of deployment |
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
| global.podSecurityContext | object | `{}` | Global security Context for all pods |
| global.restApiSubdomain | string | `"api"` | REST API subdomain which get prepended to the domain |
| host | string | `""` | Hostname for which to create rules and TLS certificates (if omitted, the host will be generated using the global subdomain and `domain` values) |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.registry | string | `""` | If defined, it will prepend the registry to the image name, if not, default docker.io will be prepended |
| image.repository | string | `"kubeshop/testkube-ai-copilot"` |  |
| image.tag | string | `"2.10.1"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `"nginx"` |  |
| ingress.enabled | bool | `true` |  |
| llmTracing | object | `{"apiKey":"","enabled":false,"secretRef":""}` | Configuration for tracing and monitoring LLM operations in Testkube Cloud. Not required for enterprise/on-premises deployments. |
| llmTracing.apiKey | string | `""` | Can be provided directly or referenced from a secret. |
| llmTracing.enabled | bool | `false` | Toggle whether to enable or disable LLM tracing |
| llmTracing.secretRef | string | `""` | Reference to the secret containing the API Key. |
| logLevel | string | `"info"` | Log level |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| oauthAudience | string | `""` | OAuth audience represents the expected value of the `aud` claim in the JWT token. This is the static client ID in the Dex configuration. |
| oauthIssuer | string | `""` | Specify issuer to skip OIDC Discovery |
| oauthJwksUri | string | `""` | Specify the URL to fetch the JWK set document and skip OIDC Discovery |
| oidcDiscoveryUri | string | `""` | Use OpenID Conect (OIDC) Discovery endpoint to fetch configurations from the identity provider. The path should end with `/.well-known/openid-configuration`. |
| openAi.apiKey | string | `""` | OpenAI API Key - can be provided directly or referenced from a secret |
| openAi.secretRef | string | `""` | Reference to the secret containing the OpenAI API Key. Place value into `OPENAI_API_KEY` key. |
| podAnnotations | object | `{}` |  |
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
