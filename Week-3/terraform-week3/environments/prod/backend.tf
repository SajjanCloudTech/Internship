
terraform {
  backend "s3" {
    bucket         = "sajjan-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}