variable "aws_region" {
  default = "us-east-2"
}

variable "ami_id" {
  default = "ami-018875e7376831abe"
}

variable "instance_type" {
  default = "t3.small"
}

variable "key_pair" {
  default = "SajjanKeyPair"
}

variable "vpc_id" {
  description = "Existing VPC ID where the EC2 instance will be launched"
  default     = "vpc-0c64ade77007aee15"
}

variable "security_group_id" {
  description = "Existing Security Group ID to use for EC2"
  default     = "sg-0481758867d90e7f3"
}

variable "subnet_id" {
  description = "The specific subnet ID where the EC2 instance will be launched"
  default     = "subnet-0cf37bc1ff077de06"
}
