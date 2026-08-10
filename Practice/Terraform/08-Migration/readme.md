# Migration
When an infrastructure resource, such as an EC2 instance, is already running and you want to start managing it using Infrastructure as Code (IaC) with Terraform, you can import the existing resource into Terraform. 

## Creating the Terraform Configuration

Terraform provides commands that can help you migrate existing infrastructure into Terraform management.
```hcl
terraform init
terraform plan -generate-config-out=<filename>  # creates a new config file have details of all the details of the already existing resource
```
The terraform plan -generate-config-out command generates a Terraform configuration file containing the configuration details detected for the existing resource.

---
You can then import the existing resource into Terraform:
```hcl
terraform import <resource-name> <resource_id> 
#For example:

#terraform import aws_instance.example i-0123456789abcdef0

```
The import operation associates the existing infrastructure resource with the specified Terraform resource. Terraform records this association in the state file, allowing Terraform to manage the existing resource going forward.

After importing the resource, review the generated configuration and run:

```
terraform plan
```
This helps verify that the Terraform configuration matches the actual infrastructure and identifies any differences that Terraform would attempt to change.