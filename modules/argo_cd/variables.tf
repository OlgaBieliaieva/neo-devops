variable "cluster_name" { type = string }
variable "cluster_endpoint" { type = string }
variable "cluster_ca" { type = string }

variable "argocd_namespace" {
  type    = string
  default = "argocd"
}

variable "helm_chart_repo" {
  type    = string
  default = "https://argoproj.github.io/argo-helm"
}

variable "helm_chart_path" {
  type    = string
  default = "argo-cd"
}

variable "argocd_chart_version" {
  type    = string
  default = "5.23.4"
}

variable "argocd_repo_url" {
  type    = string
  default = "https://github.com/OlgaBieliaieva/neo-devops"
}

