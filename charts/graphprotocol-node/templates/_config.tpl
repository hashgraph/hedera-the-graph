# Config.toml based on https://github.com/graphprotocol/graph-node/blob/5613dca92213810b3cca57979f5facc2d670e34a/docs/config.md#configuring-multiple-databases
{{- define "graphprotocol-node.config" -}}
{{- $pgDB := required "postgres.db wasn't specified" .Values.postgres.db }}
[store]
[store.primary]
  connection = "postgresql://$PG_USERNAME:$PG_PASS@$PG_HOST/{{ $pgDB }}"
  weight = 1
  pool_size = 10

[chains]
  ingestor = "{{ .Values.blockIngestorNodeId }}"
  {{- range $name, $conf := .Values.config.chains }}
  [chains.{{ $name }}]
    shard = "primary"
    {{- range $conf.providers }}
    [[chains.{{ $name }}.provider]]
      label = {{ .label | quote }}
      url = {{ .url | quote }}
      features = {{ toJson .features }}
      transport = {{ default "rpc" .transport | quote }}
      {{- with .headers }}
      [headers]
        {{- range $k, $v := . }}
        {{ $k }} = {{ $v | quote }}
        {{- end }}
      {{- end}}
    {{- end }}
  {{- end }}

[deployment]
[[deployment.rule]]
  shard = "primary"
  indexers = [ "{{ .Values.blockIngestorNodeId }}" ]
{{- end }}
