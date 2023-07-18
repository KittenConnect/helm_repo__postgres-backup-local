{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "postgres-backup-local.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "postgres-backup-local.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "postgres-backup-local.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "postgres-backup-local.labels" -}}
helm.sh/chart: {{ include "postgres-backup-local.chart" . }}
monitoring: apps
{{ include "postgres-backup-local.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "postgres-backup-local.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postgres-backup-local.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Name of the Secret that contains the PostgreSQL password
*/}}
{{- define "postgres-backup-local.secret" -}}
  {{- if .Values.auth.existingSecret }}
    {{- .Values.auth.existingSecret }}
  {{- else }}
    {{- include "postgres-backup-local.fullname" . }}
  {{- end }}
{{- end }}

{{/*
Name of the key in Secret that contains the PostgreSQL password
*/}}
{{- define "postgres-backup-local.secretPasswordKey" -}}
  {{- if .Values.auth.existingSecret -}}
    {{- .Values.auth.existingSecretPasswordKey -}}
  {{- else -}}
    postgresql-password
  {{- end -}}
{{- end }}
