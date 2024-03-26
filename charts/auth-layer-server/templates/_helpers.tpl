{{/*
Define a function to choose a value from .Values.global.auth.clientSecret, .Values.clientSecret, or generate a random string.
*/}}
{{- define "auth.clientSecret" -}}
{{- if .Values.global.auth.clientSecret -}}
  {{- .Values.global.auth.clientSecret -}}
{{- else if .Values.clientSecret -}}
  {{- .Values.clientSecret -}}
{{- else -}}
  {{- randAlphaNum 32 -}}
{{- end -}}
{{- end -}}
