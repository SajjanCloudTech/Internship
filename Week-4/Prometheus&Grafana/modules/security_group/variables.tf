variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "security_group_name" {
  default = "NodeJS-SecurityGroup"
  description = "Name of the security group"
}
