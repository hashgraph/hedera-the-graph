{{/* vim: set filetype=mustache: */}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hedera-the-graph.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "hedera-the-graph.name" -}}
{{- if .Values.global.useReleaseForNameLabel -}}
{{- .Release.Name -}}
{{- else -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Namespace
*/}}
{{- define "hedera-the-graph.namespace" -}}
{{- default .Release.Namespace .Values.global.namespaceOverride -}}
{{- end -}}

{{/*
Constructs the database host that should be used by all components.
*/}}
{{- define "hedera-the-graph.db" -}}
{{- if .Values.global.postgresql.host -}}
{{- tpl .Values.global.postgresql.host . -}}
{{- else if and .Values.postgresql.enabled (gt (.Values.postgresql.pgpool.replicaCount | int) 0) -}}
{{- include "postgresql-ha.pgpool" .Subcharts.postgresql -}}
{{- else if .Values.postgresql.enabled -}}
{{- include "postgresql-ha.postgresql" .Subcharts.postgresql -}}
{{- end -}}
{{- end -}}

{{/*
Constructs the ipfs host that should be used by all components.
*/}}
{{- define "hedera-the-graph.ipfs" -}}
{{- if .Values.ipfs.host -}}
{{- tpl .Values.ipfs.host . -}}
{{- else if .Values.ipfs.enabled -}}
{{ .Release.Name }}-ipfs:{{- .Values.ipfs.port -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "hedera-the-graph.labels" -}}
{{ include "hedera-the-graph.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: hedera-the-graph
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ include "hedera-the-graph.chart" . }}
{{- if .Values.labels }}
{{ toYaml .Values.labels }}
{{- end }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "hedera-the-graph.selectorLabels" -}}
app.kubernetes.io/component: hedera-the-graph
app.kubernetes.io/name: {{ include "hedera-the-graph.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}