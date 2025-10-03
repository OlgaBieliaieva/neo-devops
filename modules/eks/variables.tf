variable "cluster_name" { type = string }
variable "subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }
variable "region" { type = string }

variable "node_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "key_name" {
  description = "EC2 SSH key name для Node Group"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for EKS worker nodes"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet IDs for EKS cluster"
  type        = list(string)
}