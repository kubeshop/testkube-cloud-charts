{{/*
Expand the name of the chart.
*/}}
{{- define "testkube-log-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "testkube-log-service.fullname" -}}
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
{{- define "testkube-log-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common Testkube labels
*/}}
{{- define "testkube-log-service.labels" -}}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
app.kubernetes.io/component: backend
{{ include "testkube-log-service.selectorLabels" . }}
{{ include "testkube-log-service.baseLabels" . }}
{{- end }}

{{/*
Testkube selector labels
*/}}
{{- define "testkube-log-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "testkube-log-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
MinIO selector labels
*/}}
{{- define "testkube-log-service.minio.selectorLabels" -}}
app.kubernetes.io/name: testkube-cloud-minio
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Base labels
*/}}
{{- define "testkube-log-service.baseLabels" -}}
helm.sh/chart: {{ include "testkube-log-service.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: testkube-{{ if .Values.global.enterpriseMode }}enterprise{{ else }}cloud{{ end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "testkube-log-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "testkube-log-service.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get gRPC Ingress host
*/}}
{{- define "testkube-log-service.ingress.grpcHost" -}}
{{- if .Values.global.domain }}
{{- printf "%s.%s" .Values.global.grpcApiSubdomain .Values.global.domain }}
{{- else }}
{{- .Values.grpcIngress.host }}
{{- end }}
{{- end }}

{{/*
THIS IS A HACK TO WORKAROUND LET'S ENCRYPT RATE LIMITS
*/}}
{{- define "testkube-log-service.ingress.hackHost" -}}
{{- printf "health.%s" .Values.global.domain }}
{{- end }}
