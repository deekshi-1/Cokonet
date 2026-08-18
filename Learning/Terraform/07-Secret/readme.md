# Secrets Storage
Terraform can be used to securely retrieve and manage secrets stored in HashiCorp Vault, rather than storing sensitive information directly in Terraform configuration files.

## setting hashicorp vault 
HashiCorp Vault can be installed using a package manager. After installation, configure Vault and open the required port to allow access.

Once Vault is configured, authenticate using the appropriate credentials and store the required secrets securely in Vault

## Retreving the secret
The main.tf file demonstrates how to retrieve secrets from HashiCorp Vault using Terraform. This allows sensitive data to be accessed when required without storing the actual secrets directly in the Terraform configuration.