provider "aws" {
  region = "ap-south-1"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = map(string)

  default = {
    dev  = "t3.micro"
    prod = "t3.large"
    stagging = "t3.medium"
  }
}

module "ec2_instance" {
  source = "./ec2_instance_module"
  ami_value = "ami-0199ac7c9fbf9ed83"
  instance_type_value = lookup(var.instance_type, terraform.workspace, "t3.micro")
}
