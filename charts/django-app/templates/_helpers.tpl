{{/*ім’я застосунку */}}
{{- define "django-app.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{/* повне ім’я ресурсу */}}
{{- define "django-app.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}