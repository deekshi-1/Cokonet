provider "aws" {
  region = "ap-south-1"
  alias = "ap-south-1"
}

provider "aws" {
  region = "us-east-1"
  alias = "us-east-1"
}

resource "aws_instance" "sample" {
  ami           = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
  provider     = aws.ap-south-1
}

resource "aws_instance" "sample" {
  ami           = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
  provider     = aws.us-east-1
}