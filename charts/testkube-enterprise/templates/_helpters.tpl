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
app.kubernetes.io/version: {{ .Values.dex.image.tag }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: auth
app.kubernetes.io/part-of: testkube-enterprise
{{- end }}
