provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "sample" {
  ami           = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
  subnet_id     = "subnet-0bf0e12a7432481c0"
  key_name      = "mumkey"
}

// Using variables

variable "instance_type" {
  description = "The type of instance to create"
  default     = "t2.micro"
  type        = string
}



resource "aws_instance" "variable_instance" {
  ami           = "ami-01a00762f46d584a1"
  instance_type = var.instance_type
  subnet_id     = "subnet-0bf0e12a7432481c0"
  key_name      = "mumkey"
}