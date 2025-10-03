variable "cluster_name" { type = string }
variable "cluster_endpoint" { type = string }
variable "cluster_ca" { type = string }

variable "ecr_repository" { type = string }


variable "jenkins_namespace" {
  type    = string
  default = "jenkins"
}

variable "jenkins_chart_version" {
  type    = string
  default = "4.9.0"
}

variable "jenkins_admin_password" {
  type    = string
  default = "123456"
}

variable "kaniko_role_arn" {
  type        = string
  description = "IAM Role ARN для Jenkins Kaniko Agent"
}