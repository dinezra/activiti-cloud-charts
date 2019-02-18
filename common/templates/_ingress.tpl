{{/* vim: set filetype=mustache: */}}
{{/*
Create a default tls secret name.
*/}}
{{- define "common.ingress-tlssecretname" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $tlssecretname := default (printf "tls-%s-%s" .Release.Name .Chart.Name) .Values.ingress.tlsSecret -}}
		{{- tpl (printf "%s" $tlssecretname) $ | trunc 48 | trimSuffix "-" -}}
	{{- end -}}
{{- end -}}

{{/*
Create a default ingress host.
*/}}
{{- define "common.ingress-host" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $ingressHost := default (include "common.gateway-host" .) .Values.ingress.hostName -}}
		{{- tpl (printf "%s" $ingressHost) . -}}
	{{- end -}}
{{- end -}}

{{/*
Create a default ingress path.
*/}}
{{- define "common.ingress-path" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $value := default "" .Values.ingress.path -}}
		{{- tpl (printf "%s" $value) . -}}
	{{- end -}}
{{- end -}}

{{/*
Create a default ingress tls.
*/}}
{{- define "common.ingress-tls" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- default "" (or (eq .Values.global.gateway.http false) .Values.ingress.tls) -}}
	{{- end -}}
{{- end -}}

{{/*
Create default ingress annotations
*/}}
{{- define "common.ingress-annotations" -}}
{{- $common := dict "Values" .Values.common -}} 
{{- $noCommon := omit .Values "common" -}} 
{{- $overrides := dict "Values" $noCommon -}} 
{{- $noValues := omit . "Values" -}} 
{{- $values := merge $noValues $overrides $common -}} 
{{- with $values -}}

{{- range $key, $value := .Values.global.gateway.annotations }}
{{ $key }}: {{ tpl (printf "%s" $value) $values | quote }}
{{- end }}
{{- range $key, $value := .Values.ingress.annotations }}
{{ $key }}: {{ tpl (printf "%s" $value) $values | quote }}
{{- end }}
{{- if or (eq .Values.global.gateway.http false) .Values.ingress.tls }}
{{ tpl "kubernetes.io/tls-acme: \"true\"" . }}
{{- end }}

{{- end }}
{{- end -}}