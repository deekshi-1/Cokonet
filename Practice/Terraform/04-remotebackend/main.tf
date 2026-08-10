provider "aws" {
  region = "ap-south-1"
}

# 1. Create the S3 Bucket for state storage
resource "aws_s3_bucket" "terraform_state" {
  bucket = "buckett-name" # Must be globally unique
}

# 2. Create the DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Your actual infrastructure resources go here
resource "aws_instance" "sample" {
  ami           = "ami-0199ac7c9fbf9ed83"
  instance_type = "t3.micro"
}