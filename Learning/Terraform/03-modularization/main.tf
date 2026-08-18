provider "aws" {
  region = "ap-south-1"
}

module "ec2_instance" {
  source = "./ec2_instance_module"
  ami_value = "ami-0199ac7c9fbf9ed83"
  instance_type_value = "t3.micro"
}
