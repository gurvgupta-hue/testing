provider "aws" {
  region = "us-east-1"
}

# 1. Security Group: Allow All Inbound Traffic (0.0.0.0/0)
resource "aws_security_group" "vulnerable_sg" {
  name        = "open-access-sg"
  description = "Allows SSH and HTTP from everywhere"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Vulnerability: SSH open to the world
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. S3 Bucket: Public Access and No Encryption
resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "very-secret-data-12345"
}

# Vulnerability: Explicitly making the bucket public
resource "aws_s3_bucket_public_access_block" "bad_practice" {
  bucket = aws_s3_bucket.vulnerable_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 3. IAM: Over-privileged Role (AdministratorAccess)
resource "aws_iam_role" "excessive_role" {
  name = "over-privileged-role"

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

resource "aws_iam_role_policy_attachment" "admin_attach" {
  role       = aws_iam_role.excessive_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # Vulnerability: Massive blast radius
}

# 4. EC2: Unencrypted EBS and IMDSv1 enabled
resource "aws_instance" "vulnerable_ec2" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2
  instance_type = "t2.micro"
  
  vpc_security_group_ids = [aws_security_group.vulnerable_sg.id]
  
  root_block_device {
    encrypted = false # Vulnerability: Data at rest not encrypted
  }

  metadata_options {
    http_tokens = "optional" # Vulnerability: Allows IMDSv1 (SSRF risk)
  }

  tags = {
    Name = "Vulnerable-Node"
  }
}
