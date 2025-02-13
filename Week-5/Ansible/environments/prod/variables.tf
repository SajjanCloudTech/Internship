variable "environment" {
  default = "default"
}

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "instance_type" {
  description = "The instance type for EC2"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for Terraform state locking"
  type        = string
}
