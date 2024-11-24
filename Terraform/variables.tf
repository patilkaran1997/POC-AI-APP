variable "aws_region" {
  description = "The AWS region to deploy resources."
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  default     = "demo-eks-cluster"
}

variable "node_instance_type" {
  description = "Instance type for EKS worker nodes."
  default     = "t3.medium" # Increased from t3.micro to t3.medium
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "node_desired_size" {
  description = "Desired number of nodes in the node group."
  default     = 2 # Increased from 1 to 2
}

variable "node_min_size" {
  description = "Minimum number of nodes in the node group."
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of nodes in the node group."
  default     = 3 # Allows scaling up if needed
}

variable "tags" {
  description = "Tags to be applied to all resources."
  default     = {
    Environment = "dev"
    Project     = "demo-eks"
  }
}
