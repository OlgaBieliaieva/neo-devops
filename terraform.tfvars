aws_region = "eu-central-1"

key_name = "lesson9-eks-key"

tfstate_bucket = "terraform-state-bucket-l9"
tfstate_table  = "terraform-locks"

vpc_cidr_block = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
private_subnets = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
availability_zones = ["eu-central-1a","eu-central-1b","eu-central-1c"]
vpc_name = "lesson-9-vpc"

ecr_name = "lesson-9-ecr"
ecr_scan_on_push = true

cluster_name = "lesson9-eks"

helm_chart_repo = "https://github.com/OlgaBieliaieva/neo-devops"   
helm_chart_path = "charts/django-app"