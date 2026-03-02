{{/*
Expand the name of the chart.
*/}}
{{- define "pdb-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
Truncated at 63 chars (DNS naming spec).
*/}}
{{- define "pdb-operator.fullname" -}}
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
{{- define "pdb-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "pdb-operator.labels" -}}
helm.sh/chart: {{ include "pdb-operator.chart" . }}
{{ include "pdb-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "pdb-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pdb-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
control-plane: {{ include "pdb-operator.fullname" . }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "pdb-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "pdb-operator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Webhook service name.
*/}}
{{- define "pdb-operator.webhookServiceName" -}}
{{- printf "%s-webhook" (include "pdb-operator.fullname" .) }}
{{- end }}

{{/*
Metrics service name.
*/}}
{{- define "pdb-operator.metricsServiceName" -}}
{{- printf "%s-metrics" (include "pdb-operator.fullname" .) }}
{{- end }}

{{/*
Webhook certificate secret name.
*/}}
{{- define "pdb-operator.webhookCertSecretName" -}}
{{- printf "%s-webhook-cert" (include "pdb-operator.fullname" .) }}
{{- end }}

{{/*
Container image reference.
*/}}
{{- define "pdb-operator.image" -}}
{{- printf "%s:%s" .Values.image.repository (default .Chart.AppVersion .Values.image.tag) }}
{{- end }}
