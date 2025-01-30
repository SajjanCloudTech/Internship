provider "aws" {
  region  = "us-east-2"
 # profile = "default"
 access_key = data.vault_kv_secret_v2.aws_creds.data.data["access_key"]
 secret_key = data.vault_kv_secret_v2.aws_creds.data.data["secret_key"]
 token = data.vault_kv_secret_v2.aws_creds.data.data["token"]
}

provider "vault" {
  address = "http://18.118.27.69:8200/"
}

# Fetch AWS credentials from Vault
data "vault_kv_secret_v2" "aws_creds" {
  mount = "secret"
  name  = "aws_creds"
}

