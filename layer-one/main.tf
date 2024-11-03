provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "layer_one_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "LayerOneVPC"
  }
}

# Subnet
resource "aws_subnet" "layer_one_subnet" {
  vpc_id            = aws_vpc.layer_one_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "LayerOneSubnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "layer_one_igw" {
  vpc_id = aws_vpc.layer_one_vpc.id
}

# Route Table
resource "aws_route_table" "layer_one_route_table" {
  vpc_id = aws_vpc.layer_one_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.layer_one_igw.id
  }
}

# Route Table Association
resource "aws_route_table_association" "layer_one_route_table_association" {
  subnet_id      = aws_subnet.layer_one_subnet.id
  route_table_id = aws_route_table.layer_one_route_table.id
}

# Output VPC ID
output "vpc_id" {
  value = aws_vpc.layer_one_vpc.id
}

# Output Subnet ID
output "subnet_id" {
  value = aws_subnet.layer_one_subnet.id
}
