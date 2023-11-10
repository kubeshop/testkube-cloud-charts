{{/*
Expand the name of the chart.
*/}}
{{- define "testkube-cloud-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "testkube-cloud-api.fullname" -}}
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

{{/* MinIO
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "testkube-cloud-api.minio.fullname" -}}
{{- if .Values.minio.fullnameOverride }}
{{- .Values.minio.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.minio.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}-minio
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "testkube-cloud-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common Testkube labels
*/}}
{{- define "testkube-cloud-api.labels" -}}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
app.kubernetes.io/component: backend
{{ include "testkube-cloud-api.selectorLabels" . }}
{{ include "testkube-cloud-api.baseLabels" . }}
{{- end }}

{{/*
Common Testkube labels
*/}}
{{- define "testkube-cloud-api-migrations.labels" -}}
app.kubernetes.io/component: backend
{{ include "testkube-cloud-api.selectorLabels" . }}
{{ include "testkube-cloud-api.baseLabels" . }}
{{- end }}

{{/*
Testkube selector labels
*/}}
{{- define "testkube-cloud-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "testkube-cloud-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common MinIO labels
*/}}
{{- define "testkube-cloud-api.minio.labels" -}}
app.kubernetes.io/version: {{ .Values.minio.image.tag | quote }}
app.kubernetes.io/component: storage
{{ include "testkube-cloud-api.minio.selectorLabels" . }}
{{ include "testkube-cloud-api.baseLabels" . }}
{{- end }}

{{/*
MinIO selector labels
*/}}
{{- define "testkube-cloud-api.minio.selectorLabels" -}}
app.kubernetes.io/name: testkube-cloud-minio
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Base labels
*/}}
{{- define "testkube-cloud-api.baseLabels" -}}
helm.sh/chart: {{ include "testkube-cloud-api.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: testkube-{{ if .Values.global.enterpriseMode }}enterprise{{ else }}cloud{{ end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "testkube-cloud-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "testkube-cloud-api.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use for MinIO
*/}}
{{- define "testkube-cloud-api.minio.serviceAccountName" -}}
{{- if .Values.minio.serviceAccount.create }}
{{- default (include "testkube-cloud-api.fullname" .) .Values.minio.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.minio.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the MinIO service account name for the Deployment
*/}}
{{- define "testkube-cloud-api.minio.findServiceAccountName" -}}
{{- if .Values.minio.serviceAccount.create }}
{{- default (include "testkube-cloud-api.minio.fullname" .) .Values.minio.serviceAccount.name }}
{{- else if .Values.minio.customServiceAccountName }}
{{- .Values.minio.customServiceAccountName }}
{{- else }}
{{- default "default" .Values.minio.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get REST Ingress host
*/}}
{{- define "testkube-cloud-api.ingress.restHost" -}}
{{- if .Values.global.domain }}
{{- printf "%s.%s" .Values.global.restApiSubdomain .Values.global.domain }}
{{- else }}
{{- .Values.restIngress.host }}
{{- end }}
{{- end }}

{{/*
Get gRPC Ingress host
*/}}
{{- define "testkube-cloud-api.ingress.grpcHost" -}}
{{- if .Values.global.domain }}
{{- printf "%s.%s" .Values.global.grpcApiSubdomain .Values.global.domain }}
{{- else }}
{{- .Values.grpcIngress.host }}
{{- end }}
{{- end }}

{{/*
Get Websockets Ingress host
*/}}
{{- define "testkube-cloud-api.ingress.websocketsHost" -}}
{{- if .Values.global.domain }}
{{- printf "%s.%s" .Values.global.websocketApiSubdomain .Values.global.domain }}
{{- else }}
{{- .Values.websocketsIngress.host }}
{{- end }}
{{- end }}

{{/*
Get Status Pages Ingress host
*/}}
{{- define "testkube-cloud-api.ingress.statusPagesHost" -}}
{{- if .Values.global.domain }}
{{- printf "%s.%s" .Values.global.statusPagesApiSubdomain .Values.global.domain }}
{{- else }}
{{- .Values.statusPagesIngress.host }}
{{- end }}
{{- end }}
