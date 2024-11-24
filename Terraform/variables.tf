variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  default     = "mern-eks-cluster"
}

variable "node_instance_type" {
  description = "Instance type for worker nodes"
  default     = "t3.medium"
}

variable "desired_node_count" {
  description = "Desired number of worker nodes"
  default     = 2
}

variable "max_node_count" {
  description = "Maximum number of worker nodes"
  default     = 3
}

variable "min_node_count" {
  description = "Minimum number of worker nodes"
  default     = 1
}
