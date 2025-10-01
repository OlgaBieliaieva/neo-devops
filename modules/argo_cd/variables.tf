variable "cluster_name" { type = string }
variable "kubeconfig" { type = string }

variable "helm_chart_repo" { type = string }
variable "helm_chart_path" { type = string }

variable "argocd_namespace" {
  type    = string
  default = "argocd"
}

variable "argocd_chart_version" {
  type    = string
  default = "5.23.4"
}

variable "argocd_repo_url" {
  type    = string
  default = "https://github.com/OlgaBieliaieva/neo-devops/tree/lesson-8-9"
}
