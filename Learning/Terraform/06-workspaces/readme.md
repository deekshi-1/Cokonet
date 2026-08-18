# Workspaces 
- Terraform Workspaces are an isolated Terraform state for the same Terraform configuration, allowing you to manage multiple environments without duplicating your code.
- A workspace primarily gives you separate Terraform state. It does not automatically create different infrastructure.

## Why workspaces
Imagine you manage an application with:EC2,RDS,S3,VPC You need three environments:dev,staging and prod.Without workspaces, you might copy your Terraform code:terraform-dev/,terraform-staging/,terraform-prod/.That creates duplication and makes maintenance harder.With workspaces,You keep one set of Terraform files, but each workspace has its own state.

---
For serious production setups, teams often prefer separate Terraform configurations/directories or separate HCP Terraform workspaces, especially when environments need different permissions, credentials, or infrastructure architecture.
---

## Working with workspaces

- **Create :**terraform workspace new dev 
- **List:**terraform workspace list 
- **Show current workspace:**terraform workspace show 
- **Switch :**terraform workspace select prod 
- **Delete :**terraform workspace delete dev

## Using Workspace in Terraform

```
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
```
This Terraform code defines a variable called instance_type as a map of strings, where different Terraform workspaces are mapped to different EC2 instance types. For example, the dev workspace uses t3.micro, the prod workspace uses t3.large, and the stagging workspace uses t3.medium. The ec2_instance module then uses lookup() to check the current Terraform workspace using terraform.workspace and select the corresponding instance type from the map. For example, if the current workspace is dev, lookup() returns t3.micro; if it is prod, it returns t3.large. If the current workspace is not found in the map, t3.micro is used as the default value. This allows the same Terraform configuration to automatically create EC2 instances with different sizes depending on the selected workspace.

## When to Use

Use workspaces when environments have similar infrastructure but need separate state.

For complex production environments requiring different accounts, credentials, permissions, or architecture, separate Terraform configurations or HCP Terraform workspaces may be more appropriate.
