# Ensure the EKS Cluster is created with subnets from multiple AZs
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    # Use both public and private subnets from multiple AZs
    subnet_ids = concat(
      aws_subnet.public[*].id,   # Public subnets
      aws_subnet.private[*].id   # Private subnets
    )
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

# EKS Node Group - Use public subnets for worker nodes
resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "mern-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.public[*].id  # Use public subnets for worker nodes

  scaling_config {
    desired_size = var.desired_node_count
    max_size     = var.max_node_count
    min_size     = var.min_node_count
  }

  instance_types = [var.node_instance_type]
}

# IAM role for the EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach the EKS Cluster Policy to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# IAM role for EKS Node Group
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach the Worker Node Policy to the role
resource "aws_iam_role_policy_attachment" "eks_worker_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

# Fetch existing Internet Gateway for the VPC
data "aws_internet_gateway" "existing" {
  filter {
    name   = "attachment.vpc-id"
    values = [aws_vpc.main.id]
  }
}

# Create a new Internet Gateway if none exists
resource "aws_internet_gateway" "igw" {
  count = length(data.aws_internet_gateway.existing.id) == 0 ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "mern-igw"
  }
}

# Get the IGW ID (existing or new)
locals {
  igw_id = length(data.aws_internet_gateway.existing.id) > 0 ? data.aws_internet_gateway.existing.id : aws_internet_gateway.igw[0].id
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = local.igw_id
  }

  tags = {
    Name = "mern-public-route-table"
  }
}

# Associate the route table with public subnets
resource "aws_route_table_association" "public_route_table_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route_table.id
  # Ensure Terraform manages the associations properly
  depends_on = [aws_route_table.public_route_table]
}
