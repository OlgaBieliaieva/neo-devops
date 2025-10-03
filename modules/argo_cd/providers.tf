
provider "kubernetes" {
  alias                  = "argo"
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca)
  token                  = data.aws_eks_cluster_auth.this.token
}


provider "helm" {
  alias      = "argo"
  kubernetes = kubernetes.argo
}


data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}