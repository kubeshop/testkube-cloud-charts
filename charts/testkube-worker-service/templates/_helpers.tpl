{{/*
Expand the name of the chart.
*/}}
{{- define "testkube-worker-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "testkube-worker-service.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "testkube-worker-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common Testkube labels
*/}}
{{- define "testkube-worker-service.labels" -}}
{{- if not (.Values.global.noVersionLabel | default false) }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
{{- end }}
app.kubernetes.io/component: backend
{{ include "testkube-worker-service.selectorLabels" . }}
{{ include "testkube-worker-service.baseLabels" . }}
{{- if .Values.global.labels }}
{{ toYaml .Values.global.labels }}
{{- end }}
{{- end }}

{{/*
Testkube selector labels
*/}}
{{- define "testkube-worker-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "testkube-worker-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
MinIO selector labels
*/}}
{{- define "testkube-worker-service.minio.selectorLabels" -}}
app.kubernetes.io/name: testkube-cloud-minio
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Base labels
*/}}
{{- define "testkube-worker-service.baseLabels" -}}
helm.sh/chart: {{ include "testkube-worker-service.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: testkube-{{ if .Values.global.enterpriseMode }}enterprise{{ else }}cloud{{ end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "testkube-worker-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "testkube-worker-service.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get REST Ingress host
*/}}
{{- define "testkube-worker-service.ingress.restHost" -}}
{{- if .Values.global.domain }}
{{- printf "%s.%s" .Values.global.restApiSubdomain .Values.global.domain }}
{{- else }}
{{- .Values.restIngress.host }}
{{- end }}
{{- end }}

{{/*
Get gRPC Ingress host
*/}}
{{- define "testkube-worker-service.ingress.grpcHost" -}}
{{- if .Values.global.domain }}
{{- printf "%s.%s" .Values.global.grpcApiSubdomain .Values.global.domain }}
{{- else }}
{{- .Values.grpcIngress.host }}
{{- end }}
{{- end }}

{{/*
Get Websockets Ingress host
*/}}
{{- define "testkube-worker-service.ingress.websocketsHost" -}}
{{- if .Values.global.domain }}
{{- printf "%s.%s" .Values.global.websocketApiSubdomain .Values.global.domain }}
{{- else }}
{{- .Values.websocketsIngress.host }}
{{- end }}
{{- end }}

{{/*
THIS IS A HACK TO WORKAROUND LET'S ENCRYPT RATE LIMITS
*/}}
{{- define "testkube-worker-service.ingress.hackHost" -}}
{{- printf "health.%s" .Values.global.domain }}
{{- end }}

{{/*
Define image
*/}}
{{- define "testkube-worker.image" -}}
{{- $registryName := default "docker.io" .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := default .Chart.AppVersion .Values.image.tag | toString -}}
{{- $tagSuffix := .Values.image.tagSuffix -}}
{{- $separator := ":" -}}
{{- if .Values.image.digest }}
    {{- $separator = "@" -}}
    {{- $tag = .Values.image.digest | toString -}}
{{- end -}}
{{- if .Values.global }}
    {{- if .Values.global.testkubeVersion -}}
        {{- $tag = .Values.global.testkubeVersion | toString -}}
    {{- end -}}

    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s%s%s%s" .Values.global.imageRegistry $repositoryName $separator $tag $tagSuffix -}}
    {{- else -}}
        {{- printf "%s/%s%s%s%s" $registryName $repositoryName $separator $tag $tagSuffix -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s%s%s%s" $registryName $repositoryName $separator $tag $tagSuffix -}}
{{- end -}}
{{- end -}}

{{/*
Define podSecurityContext
*/}}
{{- define "testkube-worker-service.podSecurityContext" -}}
{{- if .Values.global.podSecurityContext }}
{{ toYaml .Values.global.podSecurityContext }}
{{- else }}
{{ toYaml .Values.podSecurityContext }}
{{- end }}
{{- end }}

{{/*
Define containerSecurityContext
*/}}
{{- define "testkube-worker-service.containerSecurityContext" -}}
{{- if .Values.global.containerSecurityContext }}
{{- toYaml .Values.global.containerSecurityContext}}
{{- else }}
{{- toYaml .Values.securityContext }}
{{- end }}
{{- end }}

{{/*
Define containerSecurityContext for Init Container
*/}}
{{- define "init-wait-for-mongo.containerSecurityContext" -}}
{{- if .Values.global.containerSecurityContext }}
{{- toYaml .Values.global.containerSecurityContext }}
{{- else }}
{{- toYaml .Values.init.mongo.containerSecurityContext }}
{{- end }}
{{- end }}