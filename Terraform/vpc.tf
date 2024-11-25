# Fetch Available Availability Zones
data "aws_availability_zones" "available" {}

# VPC Creation
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "mern-vpc"
  }
}

# Public Subnets in Multiple AZs
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id                    = aws_vpc.main.id
  cidr_block                = var.public_subnet_cidrs[count.index]
  availability_zone         = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch   = true
  tags = {
    Name = "mern-public-subnet-${count.index}"
  }
}

# Private Subnets in Multiple AZs
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id                    = aws_vpc.main.id
  cidr_block                = var.private_subnet_cidrs[count.index]
  availability_zone         = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "mern-private-subnet-${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "mern-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "mern-public-route-table"
  }
}

# Route for Public Subnet
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Route Table Association for Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
