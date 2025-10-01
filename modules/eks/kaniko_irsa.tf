resource "random_id" "kaniko_id" {
  byte_length = 4
}

data "aws_caller_identity" "current" {}

locals {
  oidc_url = replace(aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
}

resource "aws_iam_role" "kaniko" {
  name = "${var.cluster_name}-kaniko-role-${random_id.kaniko_id.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Federated = aws_iam_openid_connect_provider.oidc.arn },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${local.oidc_url}:sub" = "system:serviceaccount:jenkins:jenkins-agent"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "kaniko_ecr_policy" {
  name = "kaniko-ecr-policy-${random_id.kaniko_id.hex}"
  role = aws_iam_role.kaniko.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Effect = "Allow", Action = ["ecr:GetAuthorizationToken"], Resource = "*" },
      {
        Effect = "Allow",
        Action = [
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
          "ecr:CreateRepository"
        ],
        Resource = "arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/*"
      },
      {
        Effect = "Allow",
        Action = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],
        Resource = "*"
      }
    ]
  })
}