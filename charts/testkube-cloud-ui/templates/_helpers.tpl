{{/*
Expand the name of the chart.
*/}}
{{- define "testkube-cloud-ui.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "testkube-cloud-ui.fullname" -}}
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
{{- define "testkube-cloud-ui.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "testkube-cloud-ui.labels" -}}
helm.sh/chart: {{ include "testkube-cloud-ui.chart" . }}
{{ include "testkube-cloud-ui.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: frontend
app.kubernetes.io/part-of: testkube-{{ if .Values.global.enterpriseMode }}enterprise{{ else }}cloud{{ end }}
{{- if .Values.global.labels }}
{{ toYaml .Values.global.labels }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "testkube-cloud-ui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "testkube-cloud-ui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "testkube-cloud-ui.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "testkube-cloud-ui.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get Ingress host
*/}}
{{- define "testkube-cloud-ui.ingress.host" -}}
{{- .Values.ingress.host }}
{{- if .Values.global.domain }}
{{- printf "%s.%s" .Values.global.uiSubdomain .Values.global.domain }}
{{- end }}
{{- end }}

{{/*
Define image
*/}}
{{- define "testkube-dashboard.image" -}}
{{- $registryName := default "docker.io" .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := default .Chart.AppVersion .Values.image.tag | toString -}}
{{- $separator := ":" -}}
{{- if .Values.image.digest }}
    {{- $separator = "@" -}}
    {{- $tag = .Values.image.digest | toString -}}
{{- end -}}
{{- if .Values.sandboxImage.tag }}
    {{- $repositoryName = .Values.sandboxImage.repository -}}
    {{- $tag = .Values.sandboxImage.tag -}}
{{- end -}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- $registryName = .Values.global.imageRegistry -}}
    {{- end -}}
{{- end -}}
{{- printf "%s/%s%s%s" $registryName $repositoryName $separator $tag -}}
{{- end -}}