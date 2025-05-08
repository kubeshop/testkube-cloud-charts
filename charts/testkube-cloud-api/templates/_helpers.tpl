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
{{- if not (.Values.global.noVersionLabel | default false) }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
{{- end }}
app.kubernetes.io/component: backend
{{ include "testkube-cloud-api.selectorLabels" . }}
{{ include "testkube-cloud-api.baseLabels" . }}
{{- if .Values.global.labels }}
{{ toYaml .Values.global.labels }}
{{- end }}
{{- end }}

{{/*
Testkube selector labels
*/}}
{{- define "testkube-cloud-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "testkube-cloud-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
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
Get SCIM Ingress host
*/}}
{{- define "testkube-cloud-api.ingress.scimHost" -}}
{{- if .Values.global.domain }}
{{- printf "%s.%s" .Values.global.scimApiSubdomain .Values.global.domain }}
{{- else }}
{{- .Values.scimIngress.host }}
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
Define API image
*/}}
{{- define "testkube-api.image" -}}
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
Define Migration image
*/}}
{{- define "testkube-migration.image" -}}
{{- $registryName := default "docker.io" .Values.migrationImage.registry -}}
{{- $repositoryName := .Values.migrationImage.repository -}}
{{- $tag := default .Chart.AppVersion .Values.migrationImage.tag | toString -}}
{{- $tagSuffix := .Values.image.tagSuffix -}}
{{- $separator := ":" -}}
{{- if .Values.migrationImage.digest }}
    {{- $separator = "@" -}}
    {{- $tag = .Values.migrationImage.digest | toString -}}
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
{{- define "testkube-cloud-api.podSecurityContext" -}}
{{- if .Values.global.podSecurityContext }}
{{ toYaml .Values.global.podSecurityContext }}
{{- else }}
{{ toYaml .Values.podSecurityContext }}
{{- end }}
{{- end }}

{{/*
Define containerSecurityContext
*/}}
{{- define "testkube-cloud-api.containerSecurityContext" -}}
{{- if .Values.global.containerSecurityContext }}
{{- toYaml .Values.global.containerSecurityContext }}
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

{{- define "testkube-cloud-api.jobNameSuffix" -}}
{{-   if .Values.global.job.nameSuffixOverride -}}
{{-     tpl .Values.global.job.nameSuffixOverride . -}}
{{-   else -}}
{{-     printf "%d" .Release.Revision -}}
{{-   end -}}
{{- end -}}

{{- define "testkube-cloud-api.migration-jobname" -}}
{{- $fname := printf "%s-migration" (include "testkube-cloud-api.fullname" .) | trunc 55 | trimSuffix "-" -}}
{{- $name := $fname | trunc 55 | trimSuffix "-" -}}
{{- $suffix := ( include "testkube-cloud-api.jobNameSuffix" . )}}
{{- printf "%s-%s" $name $suffix  | trunc 63 | trimSuffix "-" -}}
{{- end -}}
