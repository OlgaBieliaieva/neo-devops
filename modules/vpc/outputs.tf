output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnets" {
  value = [for s in aws_subnet.private : s.id]
}

output "eks_worker_sg_id" {
  description = "Security group for EKS worker nodes"
  value       = aws_security_group.eks_worker_sg.id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}