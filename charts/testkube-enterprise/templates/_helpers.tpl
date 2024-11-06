{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "testkube-enterprise.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "testkube-enterprise.labels" -}}
helm.sh/chart: {{ include "testkube-enterprise.chart" . }}
app.kubernetes.io/version: {{ .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: auth
app.kubernetes.io/part-of: testkube-enterprise
{{- end }}

{{/*
Get Storage Ingress host
*/}}
{{- define "testkube-enterprise.ingress.storageHost" -}}
{{- if .Values.global.domain }}
{{- printf "%s.%s" .Values.global.storageApiSubdomain .Values.global.domain }}
{{- else }}
{{- .Values.minio.customIngress.host }}
{{- end }}
{{- end }}

{{/*
Define API image
*/}}
{{- define "testkube-shared-secrets.image" -}}
{{- $registryName := default "docker.io" .Values.sharedSecretGenerator.image.registry -}}
{{- $repositoryName := default "bitnami/kubectl" .Values.sharedSecretGenerator.image.repository -}}
{{- $tag := default "1.28.2" .Values.sharedSecretGenerator.image.tag | toString -}}
{{- $separator := ":" -}}
{{- if .Values.sharedSecretGenerator.image.digest }}
    {{- $separator = "@" -}}
    {{- $tag = .Values.sharedSecretGenerator.image.digest | toString -}}
{{- end -}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s%s%s" .Values.global.imageRegistry $repositoryName $separator $tag -}}
    {{- else -}}
        {{- printf "%s/%s%s%s" $registryName $repositoryName $separator $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s%s%s" $registryName $repositoryName $separator $tag -}}
{{- end -}}
{{- end -}}

{{/*
Define podSecurityContext
*/}}
{{- define "sharedSecretGenerator.podSecurityContext" -}}
{{- if .Values.global.podSecurityContext }}
{{ toYaml .Values.global.podSecurityContext }}
{{- else }}
{{ toYaml .Values.sharedSecretGenerator.podSecurityContext }}
{{- end }}
{{- end }}

{{/*
Define containerSecurityContext
*/}}
{{- define "sharedSecretGenerator.containerSecurityContext" -}}
{{- if .Values.global.containerSecurityContext }}
{{- toYaml .Values.global.containerSecurityContext}}
{{- else }}
{{- toYaml .Values.sharedSecretGenerator.securityContext }}
{{- end }}
{{- end }}
