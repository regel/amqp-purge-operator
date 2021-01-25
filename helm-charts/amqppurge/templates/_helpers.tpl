{{/*
Expand the name of the chart.
*/}}
{{- define "amqppurge.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "amqppurge.fullname" -}}
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
{{- define "amqppurge.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "amqppurge.labels" -}}
helm.sh/chart: {{ include "amqppurge.chart" . }}
{{ include "amqppurge.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "amqppurge.selectorLabels" -}}
app.kubernetes.io/name: {{ include "amqppurge.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "amqppurge.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "amqppurge.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the secret name.
*/}}
{{- define "amqppurge.secretName" -}}
{{- if .Values.amqp.existingSecret -}}
    {{- printf "%s" (tpl .Values.amqp.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-%s-%s" .Release.Name .Chart.Name "secret" }}
{{- end -}}
{{- end -}}


{{/*
Get the configmap name.
*/}}
{{- define "amqppurge.configName" -}}
{{- printf "%s-%s-%s" .Release.Name .Chart.Name "configmap" }}
{{- end -}}
