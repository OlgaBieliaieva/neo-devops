output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "jenkins_url" {
  value = module.jenkins.jenkins_url
}

output "argocd_server" {
  value = module.argo_cd.argocd_server
}