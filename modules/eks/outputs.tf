output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_ca" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "kaniko_role_arn" {
  value = aws_iam_role.kaniko.arn
}

output "eks_nodes_role_arn" {
  value = aws_iam_role.eks_nodes.arn
}

output "eks_role_arn" {
  value = aws_iam_role.eks.arn
}

