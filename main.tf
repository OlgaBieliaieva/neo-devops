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
  region = var.aws_region

  key_name           = var.key_name
  cluster_name       = var.cluster_name
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnets
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  node_instance_type = var.node_instance_type
}

module "argo_cd" {
  source           = "./modules/argo_cd"
  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca       = module.eks.cluster_ca
}

module "jenkins" {
  source           = "./modules/jenkins"
  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca       = module.eks.cluster_ca
  kaniko_role_arn  = module.eks.kaniko_role_arn
  ecr_repository   = module.ecr.repository_url
}