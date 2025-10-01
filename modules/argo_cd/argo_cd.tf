resource "kubernetes_namespace" "argocd" {
  metadata { 
    name = var.argocd_namespace 
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = var.helm_chart_repo
  chart      = var.helm_chart_path
  version    = var.argocd_chart_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  create_namespace = false

  values = [
    file("${path.module}/values.yaml")
  ]
}