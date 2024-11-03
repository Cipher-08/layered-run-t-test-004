terraform {
  backend "s3" {
    bucket         = "prod-bucket-73283278"
    key            = "layer-one/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}
provider "aws" {
  region = "ap-south-1"
}

# Import outputs from layer-one
data "terraform_remote_state" "layer_one" {
  backend = "local"
  config = {
    path = "../layer-one/terraform.tfstate"
  }
}

# IAM Role
resource "aws_iam_role" "layer_two_role" {
  name               = "LayerTwoRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# IAM Policy Attachment
resource "aws_iam_role_policy_attachment" "layer_two_policy_attach" {
  role       = aws_iam_role.layer_two_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# EC2 Instance
resource "aws_instance" "layer_two_instance" {
  ami           = "ami-0e86e20dae9224db8"  # Replace with a valid AMI
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.layer_one.outputs.subnet_id
  vpc_security_group_ids = []  # Add security group if needed

  depends_on = [data.terraform_remote_state.layer_one]
}
