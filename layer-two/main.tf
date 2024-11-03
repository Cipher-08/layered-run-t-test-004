provider "aws" {
  region = "us-east-1"
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
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.layer_one_subnet.id  # Reference from layer one
  vpc_security_group_ids = [aws_security_group.layer_one_sg.id]

  depends_on = [aws_vpc.layer_one_vpc]  # Explicit dependency on Layer One VPC
}
