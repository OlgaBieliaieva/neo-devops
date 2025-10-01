provider "kubernetes" {
  config_path = var.kubeconfig
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
  }
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}