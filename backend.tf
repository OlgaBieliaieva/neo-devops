#terraform {
#  backend "s3" {
#    bucket         = "terraform-bucket-l9"
#    key            = "l9/terraform.tfstate"
#    region         = "eu-central-1"
#    dynamodb_table = "terraform-locks"
#    encrypt        = true
#  }
#}