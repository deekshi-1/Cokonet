## 📖 Understanding the Syntax

In Terraform, configuration is written in **blocks**. Let's break down the two most important blocks used in the example above.

### 1. The Provider Block
`provider "aws"` specifies which cloud platform you are using. It tells Terraform how to interact with that specific cloud provider's API and which region to deploy your resources in.

### 2. The Resource Block
The standard format is: `resource "<resource_type>" "<local_name>"`

*   **`resource`**: The keyword telling Terraform you want to create a new piece of infrastructure.
*   **`"<resource_type>"` (e.g., `"aws_instance"`)**: The exact type of infrastructure you are building. The prefix (`aws_`) identifies the provider, and the suffix (`_instance`) identifies the specific component. 
*   **`"<local_name>"` (e.g., `"sample"`)**: A custom identifier you choose. This name is only used *internally* within your Terraform code so you can reference this component elsewhere. It does not dictate the actual name of the server in AWS.

### Inside the Resource Block (Arguments)
Inside the curly braces `{ ... }`, you provide the specific details—or "arguments"—that Terraform needs to configure that resource:

| Argument | Description |
| :--- | :--- |
| **`ami`** | **Amazon Machine Image.** Tells AWS which operating system to use (e.g., Ubuntu, Amazon Linux). Think of this as choosing the brand of your espresso machine. |
| **`instance_type`** | **Hardware Size.** Defines the CPU and memory capacity. `t3.micro` is a small, low-cost server. |
| **`subnet_id`** | **Network Location.** The exact virtual network segment where this server will live. |
| **`key_name`** | **Security Key.** The name of the SSH key pair used to securely log into the server once it is running. |

---

## 🚀 Running Terraform

Once your code is written, you manage your infrastructure using a standard command-line workflow:

1. **`terraform init`**
   Initializes your working directory. It downloads the necessary provider plugins (like the AWS plugin) so Terraform can understand your code.
   
2. **`terraform plan`**
   A dry run. This shows you a detailed preview of exactly what Terraform will create, modify, or destroy without actually making any changes.
   
3. **`terraform apply`**
   Executes the plan. Terraform will prompt you for a final `yes` before it goes to AWS and actually builds your infrastructure.
   
4. **`terraform destroy`**
   Tears everything down. This looks at your state file and permanently deletes all the resources managed by this blueprint.

---

## 🔄 Using Variables

Hardcoding values (like the `instance_type` or `ami`) isn't best practice. Instead, you can use **variable blocks** to make your code reusable. If a variable isn't passed at runtime, Terraform will use the `default` value.

**Defining the variable:**

```hcl
# variables.tf

variable "instance_size" {
  description = "The size of the EC2 instance"
  type        = string
  default     = "t3.micro"
}