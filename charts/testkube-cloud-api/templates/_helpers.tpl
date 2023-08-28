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

{{/* Base labels */}}
{{- define "testkube-cloud-api.baseLabels" -}}
helm.sh/chart: {{ include "testkube-cloud-api.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: testkube-{{ if .Values.global.enterpriseMode }}enterprise{{ else }}cloud{{ end }}
{{- end }}

{{/* Create the name of the service account to use */}}
{{- define "testkube-cloud-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "testkube-cloud-api.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Create the name of the service account to use for MinIO */}}
{{- define "testkube-cloud-api.minio.serviceAccountName" -}}
{{- if .Values.minio.serviceAccount.create }}
{{- default (include "testkube-cloud-api.fullname" .) .Values.minio.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.minio.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Get the MinIO service account name for the Deployment */}}
{{- define "testkube-cloud-api.minio.findServiceAccountName" -}}
{{- if .Values.minio.serviceAccount.create }}
{{- default (include "testkube-cloud-api.minio.fullname" .) .Values.minio.serviceAccount.name }}
{{- else if .Values.minio.customServiceAccountName }}
{{- .Values.minio.customServiceAccountName }}
{{- else }}
{{- default "default" .Values.minio.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Get REST Ingress host */}}
{{- define "testkube-cloud-api.ingress.restHost" -}}
{{- if .Values.global.domain }}
{{- printf "%s.%s" .Values.global.restApiSubdomain .Values.global.domain }}
{{- else }}
{{- .Values.restIngress.host }}
{{- end }}
{{- end }}


{{/* Get gRPC Ingress host */}}

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
Env variables
*/}}
{{- define "testkube-cloud-api.envs" }}
- name: ENTERPRISE_MODE
    value: "{{ .Values.global.enterpriseMode }}"
{{- if .Values.global.enterpriseMode }}
- name: ENTERPRISE_OFFLINE_ACTIVATION
    value: "{{ .Values.global.enterpriseOfflineAccess }}"
{{- end }}
{{- if .Values.global.enterpriseMode }}
- name: ENTERPRISE_LICENSE_KEY
    {{- if .Values.global.enterpriseLicenseSecretRef }}
    valueFrom:
    secretKeyRef:
        key: LICENSE_KEY
        name: {{ .Values.global.enterpriseLicenseSecretRef }}
    {{- else }}
    value: "{{ .Values.global.enterpriseLicenseKey }}"
    {{- end }}
{{- end }}
{{- if .Values.global.enterpriseLicenseFile }}
- name: ENTERPRISE_LICENSE_FILE
    value: "{{ .Values.global.enterpriseLicenseFile }}"
{{- end }}
- name: OPENAI_API_KEY
    {{- if .Values.ai.secretRef }}
    valueFrom:
    secretKeyRef:
        key: {{ .Values.ai.secretKey }}
        name: {{ .Values.ai.secretRef }}
    {{- else }}
    value: {{ .Values.ai.apiKey }}
    {{- end }}
- name: INVITE_MODE
    value: "{{ .Values.api.inviteMode }}"
{{- if eq .Values.api.inviteMode "email" }}
- name: SMTP_HOST
    value: "{{ .Values.api.smtp.host }}"
- name: SMTP_PORT
    value: "{{ .Values.api.smtp.port }}"
- name: SMTP_USER
    value: "{{ .Values.api.smtp.username }}"
- name: SMTP_PASSWORD
    {{- if .Values.api.smtp.passwordSecretRef }}
    valueFrom:
    secretKeyRef:
        key: SMTP_PASSWORD
        name: {{ .Values.api.smtp.passwordSecretRef }}
    {{- else }}
    value: {{ .Values.api.smtp.password }}
    {{- end }}
{{- end }}
- name: ROOT_DOMAIN
    value: "{{ .Values.global.domain }}"
- name: METRICS_LISTEN_ADDR
    value: "0.0.0.0:9100"
{{- if .Values.payments.enabled }}
- name: PAYMENTS_PORTAL_CONFIGURATION_ID
    {{- if .Values.payments.secretRef }}
    valueFrom:
    secretKeyRef:
        key: PAYMENTS_PORTAL_CONFIGURATION_ID
        name: {{ .Values.payments.secretRef }}
    {{- else }}
    value: {{ .Values.payments.portalConfigurationId }}
    {{- end }}
- name: PAYMENTS_ENDPOINT_SECRET
    {{- if .Values.payments.secretRef }}
    valueFrom:
    secretKeyRef:
        key: PAYMENTS_ENDPOINT_SECRET
        name: {{ .Values.payments.secretRef }}
    {{- else }}
    value: {{ .Values.payments.endpointSecret }}
    {{- end }}
- name: PAYMENTS_API_KEY
    {{- if .Values.payments.secretRef }}
    valueFrom:
    secretKeyRef:
        key: PAYMENTS_API_KEY
        name: {{ .Values.payments.secretRef }}
    {{- else }}
    value: {{ .Values.payments.apiKey }}
    {{- end }}
{{- end }}
{{- if .Values.analytics.segmentio.enabled }}
- name: SEGMENTIO_WRITE_KEY
    {{- if .Values.analytics.segmentio.secretRef }}
    valueFrom:
    secretKeyRef:
        key: SEGMENTIO_WRITE_KEY
        name: {{ .Values.analytics.segmentio.secretRef }}
    {{- else }}
    value: {{ .Values.analytics.segmentio.writeKey }}
    {{- end }}
{{- end }}
{{- if .Values.analytics.hubspot.enabled }}
- name: HUBSPOT_API_KEY
    {{- if .Values.analytics.hubspot.secretRef }}
    valueFrom:
    secretKeyRef:
        key: HUBSPOT_API_KEY
        name: {{ .Values.analytics.hubspot.secretRef }}
    {{- else }}
    value: {{ .Values.analytics.hubspot.apiKey }}
    {{- end }}
{{- end }}
- name: SENDGRID_API_KEY
    {{- if .Values.api.sendgrid.secretRef }}
    valueFrom:
    secretKeyRef:
        key: SENDGRID_API_KEY
        name: {{ .Values.api.sendgrid.secretRef }}
    {{- else }}
    value: "{{ .Values.api.sendgrid.apiKey }}"
    {{- end }}
- name: API_MONGO_DSN
    {{- if .Values.api.mongo.dsnSecretRef }}
    valueFrom:
    secretKeyRef:
        key: MONGO_DSN
        name: {{ .Values.api.mongo.dsnSecretRef }}
    {{- else }}
    value: {{ .Values.api.mongo.dsn }}
    {{- end }}
- name: API_MONGO_DB
    value: {{ .Values.api.mongo.database }}
- name: OAUTH_CLIENT_ID
    {{- if .Values.api.oauth.secretRef }}
    valueFrom:
    secretKeyRef:
        key: OAUTH_CLIENT_ID
        name: {{ .Values.api.oauth.secretRef }}
    {{- else }}
    value: "{{ .Values.api.oauth.clientId }}"
    {{- end }}
- name: OAUTH_CLI_CLIENT_ID
    {{- if .Values.api.oauth.secretRef }}
    valueFrom:
    secretKeyRef:
        key: OAUTH_CLI_CLIENT_ID
        name: {{ .Values.api.oauth.secretRef }}
    {{- else }}
    value: "{{ .Values.api.oauth.cliClientId }}"
    {{- end }}
- name: OAUTH_CLIENT_SECRET
    {{- if .Values.api.oauth.secretRef }}
    valueFrom:
    secretKeyRef:
        key: OAUTH_CLIENT_SECRET
        name: {{ .Values.api.oauth.secretRef }}
    {{- else }}
    value: "{{ .Values.api.oauth.clientSecret }}"
    {{- end }}
- name: OAUTH_ISSUER_URL
    {{- if .Values.api.oauth.secretRef }}
    valueFrom:
    secretKeyRef:
        key: OAUTH_ISSUER_URL
        name: {{ .Values.api.oauth.secretRef }}
    {{- else }}
    value: {{ if .Values.global.dex.issuer}}{{ .Values.global.dex.issuer }}{{ else if .Values.api.oauth.issuerUrl }}{{ .Values.api.oauth.issuerUrl }}{{ else }}https://{{ .Values.global.restApiSubdomain }}.{{ .Values.global.domain }}/idp{{ end }}
    {{- end }}
- name: OAUTH_REDIRECT_URI
    {{- if .Values.api.oauth.secretRef }}
    valueFrom:
    secretKeyRef:
        key: OAUTH_REDIRECT_URI
        name: {{ .Values.api.oauth.secretRef }}
    {{- else }}
    value: "{{ if .Values.api.oauth.redirectUri }}{{ .Values.api.oauth.redirectUri }}{{ else }}https://{{ .Values.global.restApiSubdomain }}.{{ .Values.global.domain }}/auth/callback{{ end }}"
    {{- end }}
- name: NATS_URI
    value: {{ .Values.api.nats.uri }}
{{- $dashboardAddress := "" }}
{{- if .Values.api.dashboardAddress }}
{{- $dashboardAddress = .Values.api.dashboardAddress }}
{{- else }}
{{- $dashboardAddress = printf "https://%s.%s" .Values.global.uiSubdomain .Values.global.domain }}
{{- end }}
- name: ALLOWED_EXTERNAL_REDIRECT_URIS
    value: {{ if .Values.api.oauth.allowedExternalRedirectURIs }}{{ .Values.api.oauth.allowedExternalRedirectURIs }}{{ else }}{{ $dashboardAddress }}{{ end }}
{{- if .Values.api.agent.hide }}
- name: HIDE_AGENT_HOST
    value: "{{ .Values.api.agent.hide }}"
{{- end }}
- name: AGENT_HOST
    value: {{ if .Values.api.agent.host }}{{ .Values.api.agent.host }}{{ else }}{{ .Values.global.grpcApiSubdomain }}.{{ .Values.global.domain }}{{ end }}
- name: AGENT_PORT
    value: "{{ .Values.api.agent.port }}"
- name: API_ADDRESS
    value: {{ if .Values.api.apiAddress }}{{ .Values.api.apiAddress }}{{ else }}https://{{ .Values.global.restApiSubdomain }}.{{ .Values.global.domain }}{{ end }}
- name: DASHBOARD_ADDRESS
    value: {{ $dashboardAddress }}
- name: USE_TLS
    value: "{{ .Values.api.tls.serveHTTPS }}"
- name: TLS_CERT
    value: "{{ .Values.api.tls.certPath }}"
- name: TLS_KEY
    value: "{{ .Values.api.tls.keyPath }}"
- name: OUTPUTS_BUCKET
    value: "{{ .Values.api.outputsBucket }}"
{{- if .Values.minio.enabled }}
- name: MINIO_ENDPOINT
    value: "{{ .Values.api.minio.endpoint }}"
- name: MINIO_REGION
    value: "{{ .Values.api.minio.region }}"
- name: MINIO_SSL
    value: "{{ .Values.api.minio.secure }}"
- name: MINIO_EXPIRATION
    value: "{{ .Values.api.minio.expirationPeriod }}"
- name: MINIO_ACCESS_KEY_ID
    {{- if .Values.api.minio.credsSecretRef }}
    valueFrom:
    secretKeyRef:
        key: MINIO_ACCESS_KEY_ID
        name: {{ .Values.api.minio.credsSecretRef }}
    {{- else }}
    value: "{{ if .Values.api.minio.accessKeyId }}{{ .Values.api.minio.accessKeyId }}{{ else }}{{ .Values.minio.credentials.accessKeyId }}{{ end }}"
    {{- end }}
- name: MINIO_SECRET_ACCESS_KEY
    {{- if .Values.api.minio.credsSecretRef }}
    valueFrom:
    secretKeyRef:
        key: MINIO_SECRET_ACCESS_KEY
        name: {{ .Values.api.minio.credsSecretRef }}
    {{- else }}
    value: "{{ if .Values.api.minio.secretAccessKey }}{{ .Values.api.minio.secretAccessKey }}{{ else }}{{ .Values.minio.credentials.secretAccessKey }}{{ end }}"
    {{- end }}
- name: MINIO_TOKEN
    {{- if .Values.api.minio.credsSecretRef }}
    valueFrom:
    secretKeyRef:
        key: MINIO_TOKEN
        name: {{ .Values.api.minio.credsSecretRef }}
    {{- else }}
    value: "{{ .Values.api.minio.token }}"
    {{- end }}
{{- end }}
{{ end }}