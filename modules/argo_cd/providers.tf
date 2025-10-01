provider "kubernetes" {
  host                   = data.aws_eks_cluster_auth.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster_auth.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
  }
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}