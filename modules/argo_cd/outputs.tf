output "argocd_server" {
  value = "argocd-server.${var.argocd_namespace}.svc.cluster.local"
}