variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "tfstate_bucket" {
  type    = string
  default = "terraform-state-bucket-l5"
}

variable "tfstate_table" {
  type    = string
  default = "terraform-locks"
}

variable "vpc_cidr_block" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "availability_zones" { type = list(string) }
variable "vpc_name" { type = string }

variable "ecr_name" { type = string }
variable "ecr_scan_on_push" {
  type    = bool
  default = true
}

variable "cluster_name" { type = string }

variable "helm_chart_repo" { type = string }
variable "helm_chart_path" { type = string }