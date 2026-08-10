provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "http://<ip-address>:8200"
  skip_child_token = true

  auth_login {
    path="auth/approle/login"

    parameters = {
      role_id   = "<role-id>"
      secret_id = "<secret-id>"
    }
  }
}

data "vault_kv_secret" "example" {
  path = "secret/data/example"
}

resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  tags = {
    secret_value = data.vault_kv_secret.example.data["value"]
  }
}