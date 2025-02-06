variable "ami_id" {
  default = "ami-018875e7376831abe"
}

variable "instance_type" {
  default = "t3.small"
}

variable "key_pair" {}

variable "vpc_id" {
  description = "The VPC ID where the EC2 instance will be launched"
}

variable "security_group_id" {
  description = "The security group ID to associate with the EC2 instance"
}


variable "subnet_id" {
  description = "The specific subnet ID where the EC2 instance will be launched"
}
