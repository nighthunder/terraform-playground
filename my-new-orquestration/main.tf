terraform {
  required_version = "1.4.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.60.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

resource "aws_s3_bucket" "my-test-bucket" {
  bucket = "my-test-bucket-4564592213623949234923478"
  acl    = "private"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    Managedby   = "Terraform"
    Owner       = "Maya Morais"
    UpdatedAt   = "2023-03-28"
  }
}