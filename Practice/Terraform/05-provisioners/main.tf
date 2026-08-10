provider "aws" {
  region = "ap-south-1"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair"
  public_key = file("D:/gms/newkey.pub")
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "publicSubnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table_association" "publicRouteTableAssociation" {
  subnet_id      = aws_subnet.publicSubnet.id
  route_table_id = aws_route_table.publicRouteTable.id
}

resource "aws_security_group" "appSecurityGroup" {
  name        = "app-security-group"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "app-security-group"
  }
}  

resource "aws_instance" "appInstance" {
  ami           = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.publicSubnet.id
  vpc_security_group_ids = [aws_security_group.appSecurityGroup.id]
  key_name = aws_key_pair.my_key_pair.key_name

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("D:/gms/newkey")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {
  inline = [
    "sudo apt-get update -y",
    "sudo apt-get install -y python3-pip",
    "cd /home/ubuntu",
    "python3 -m pip install --break-system-packages flask",
    "python3 app.py"
  ]
}
}
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.appInstance.public_ip
}