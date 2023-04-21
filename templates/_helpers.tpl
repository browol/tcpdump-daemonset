{{/*
Common labels
*/}}
{{- define "chartname.labels" -}}
helm.sh/chart: {{ include "chartname.chart" . }}
{{ include "chartname.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "chartname.selectorLabels" -}}
app.kubernetes.io/name: {{ include "chartname.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Chart name
*/}}
{{- define "chartname.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Chart reference in the format of <chart-name>-<chart-version>
*/}}
{{- define "chartname.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
