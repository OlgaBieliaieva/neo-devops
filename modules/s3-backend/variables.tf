variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket for Terraform state"
}

variable "table_name" {
  type        = string
  description = "Name of the DynamoDB table for Terraform state locking"
}