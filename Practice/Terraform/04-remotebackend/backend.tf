terraform {
  backend "s3" {
    bucket         = "my-unique-terraform-state-bucket"
    key            = "global/s3/terraform.tfstate"      # The file path inside S3
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-locks"            # Enables state locking
    encrypt        = true                               # Ensures state is encrypted at rest
  }
}

provider "aws" {
  region = "ap-south-1"
}

