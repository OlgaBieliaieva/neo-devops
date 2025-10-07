resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = { Name = "${var.vpc_name}-igw" }
}

resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnets : idx => cidr }
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnets : idx => cidr }
  vpc_id     = aws_vpc.this.id
  cidr_block = each.value
  availability_zone = var.availability_zones[each.key]

  tags = {
    Name = "${var.vpc_name}-private-${each.key}"
  }
}

# Security group для EKS worker nodes
resource "aws_security_group" "eks_worker_sg" {
  name        = "lesson9-eks-worker-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = aws_vpc.this.id

  # Дозволяємо трафік між воркерами і control plane
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Вихідний трафік — дозволити все
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lesson9-eks-worker-sg"
  }
}