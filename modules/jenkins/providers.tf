provider "kubernetes" {
  alias                  = "jenkins"
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  alias      = "jenkins"
  kubernetes = kubernetes.jenkins
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}