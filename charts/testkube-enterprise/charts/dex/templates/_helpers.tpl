{{/*
Expand the name of the chart.
*/}}
{{- define "dex.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dex.fullname" -}}
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
{{- define "dex.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dex.labels" -}}
helm.sh/chart: {{ include "dex.chart" . }}
{{ include "dex.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.commonLabels}}
{{ toYaml .Values.commonLabels }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dex.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dex.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "dex.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "dex.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the secret containing the config file to use
*/}}
{{- define "dex.configSecretName" -}}
{{- if .Values.configSecret.create }}
{{- default (include "dex.fullname" .) .Values.configSecret.name }}
{{- else }}
{{- default "default" .Values.configSecret.name }}
{{- end }}
{{- end }}

{{/*
The name of the image
*/}}
{{- define "dex.image" }}
{{- $image := printf "%s:%s" .Values.image.repository (default (printf "v%s" .Chart.AppVersion) .Values.image.tag) }}
{{- if or .Values.image.registry .Values.global.imageRegistry }}
{{- $image = printf "%s/%s" (default .Values.image.registry .Values.global.imageRegistry) $image }}
{{- end -}}
image: {{ $image }}
{{- end }}

{{/*
Define podSecurityContext
*/}}
{{- define "dex.podSecurityContext" -}}
{{- if .Values.global.podSecurityContext }}
{{ toYaml .Values.global.podSecurityContext }}
{{- else }}
{{ toYaml .Values.podSecurityContext }}
{{- end }}
{{- end }}

{{/*
Define containerSecurityContext
*/}}
{{- define "dex.containerSecurityContext" -}}
{{- if .Values.global.containerSecurityContext }}
{{- toYaml .Values.global.containerSecurityContext }}
{{- else }}
{{- toYaml .Values.securityContext }}
{{- end }}
{{- end }}
