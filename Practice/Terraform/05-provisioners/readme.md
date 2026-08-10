# Terraform AWS EC2 Provisioners
This project demonstrates how to use Terraform provisioners to configure an AWS EC2 instance after Terraform creates the required infrastructure.

### The Terraform configuration creates:
* An AWS VPC
* A public subnet
* An Internet Gateway
* A public route table
* A security group
* An EC2 key pair
* An EC2 instance
* A connection to the EC2 instance using SSH
* A file provisioner to upload an application
* A remote-exec provisioner to install dependencies and start the application

The example uses an Ubuntu EC2 instance and a Python Flask application.

## What are Terraform Provisioners?
- In Terraform, provisioners are used to execute commands or transfer files after Terraform creates a resource.

- They are useful when you need to perform additional configuration that cannot easily be handled through normal Terraform resources.
## 3 main provisioner types
- **file provisioner 📁 :** Used to copy files from your local machine to a resource.
```hcl
provisioner "file" {
  source      = "app.py"
  destination = "/home/ubuntu/app.py"
}
```
- **remote-exec provisioner 💻 :**Used to run commands on the remote resource, usually through SSH.
```hcl
provisioner "remote-exec" {
  inline = [
    "sudo apt update",
    "sudo apt install -y python3-pip"
  ]
}
```
- **local-exec provisioner 🖥️ :**Used to run commands on the machine where Terraform is running.
```hcl
provisioner "local-exec" {
  command = "echo EC2 created successfully"
}
```
```hcl
file
  ↓
Copy files
PC ──────────→ EC2


remote-exec
  ↓
Run commands remotely
PC ──SSH─────→ EC2


local-exec
  ↓
Run commands locally
PC ──────────→ PC
```
---

## Project Architecture
```hcl
                        AWS
                         | 
                   ┌─────┴─────┐ 
                   |    VPC    | 
                   |10.0.0.0/16| 
                   └─────┬─────┘ 
                         |
                   Public Subnet 
                   10.0.1.0/24 
                        |
                 ┌──────┴──────┐ 
                 |     EC2     | 
                 |  t3.micro   |
                 |   Ubuntu    | 
                 └──────┬──────┘ 
                        | 
                    Flask App 
                      :5000 
                        | 
                Internet Gateway 
                        | 
                    Internet
```
---
## Terraform Code Flow


The infrastructure is created in the following logical order:
```
1. AWS Provider
       ↓
2. Variable
       ↓
3. Key Pair
       ↓
4. VPC
       ↓
5. Public Subnet
       ↓
6. Internet Gateway
       ↓
7. Route Table
       ↓
8. Route Table Association
       ↓
9. Security Group
       ↓
10. EC2 Instance
       ↓
11. SSH Connection
       ↓
12. File Provisioner
       ↓
13. Remote-Exec Provisioner
       ↓
14. Flask Application
       ↓
15. Output Public IP
```