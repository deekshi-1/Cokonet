# Modularizing Terraform: EC2 Instance Example

This repository contains simple Terraform code demonstrating how to boot up an Amazon EC2 instance. The primary focus of this project is **modularizing** Terraform infrastructure to make it scalable, reusable, and easier to maintain.

---

## Benefits of Modularizing 

Breaking down Terraform code into smaller, reusable modules offers several key advantages:

- **Reusability:** You can write the code for a resource (like an EC2 instance) once and reuse it across multiple environments (e.g., Dev, QA, Prod) without duplicating code.
- **Maintainability:** Updates or bug fixes only need to be made in one place (the module itself), making the codebase much easier to manage.
- **Readability:** Abstracting complex infrastructure into logical modules keeps your root configuration files clean, concise, and easy to understand.
- **Consistency & Standardization:** Modules ensure that infrastructure is deployed using standardized configurations (like specific security groups, tags, or naming conventions) across your entire organization.

---

## Project Structure

Inside the `ec2_instance` module, the configuration is organized into standard Terraform files. Here is a breakdown of what each file does:

### 1. `variables.tf`
This file is used to define the input variables for the module. It acts as the module's "API," allowing you to pass specific values (like AMI ID, instance type, or tags) into the module without hardcoding them. 

### 2. `outputs.tf`
Here, we define the outputs of the module. Once the resources are created, this file dictates what information gets passed back to the root module or displayed to the user (e.g., the newly created EC2 instance's Public IP or ID).

### 3. `terraform.tfvars` (or `*.tfvars`)
This file is used to assign actual values to the variables defined in `variables.tf`. Users can write their own `.tfvars` files to override the default variable values. This is especially useful for managing different environments with the same module.

### 4. `main.tf`
This is the core configuration file for the module. It contains the actual resource definitions (e.g., `resource "aws_instance" "example" { ... }`) that tell Terraform what services to provision.

---

## How It Works

At the root of the project, there is a primary `main.tf` file. This root file calls the `ec2_instance` module using a `module` block and the `source` argument. 

Inside this module block, we pass the specific values for the variables required by the module.

### Example Root `main.tf`:

```hcl
module "my_ec2_instance" {
  source = "./ec2_instance" # Path to the module directory

  # Passing values to the variables defined in the module
  instance_type = "t2.micro"
  ami_id        = "ami-0c55b159cbfafe1f0"
  instance_name = "MyModularizedServer"
}