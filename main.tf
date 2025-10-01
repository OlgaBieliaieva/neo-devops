provider "aws" {
  region = var.aws_region
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = var.tfstate_bucket
  table_name  = var.tfstate_table
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  vpc_name           = var.vpc_name
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = var.ecr_name
  scan_on_push = var.ecr_scan_on_push
}

module "eks" {
  source = "./modules/eks"

  cluster_name   = var.cluster_name
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnets
  node_instance_type = "t3.medium"
}

module "argo_cd" {
  source = "./modules/argo_cd"

  cluster_name     = module.eks.cluster_name
  kubeconfig       = module.eks.kubeconfig_raw   # новий output у модулі eks
  helm_chart_repo  = var.helm_chart_repo
  helm_chart_path  = var.helm_chart_path
  argocd_namespace = "argocd"
  argocd_chart_version = "5.23.4"
}

module "jenkins" {
  source = "./modules/jenkins"

  cluster_name   = module.eks.cluster_name
  kubeconfig     = module.eks.kubeconfig_raw
  kaniko_role_arn = module.eks.kaniko_role_arn
  ecr_repository = module.ecr.repository_url
}

