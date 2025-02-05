variable "ami_id" {
  default = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_pair" {}

variable "vpc_id" {
  description = "The VPC ID where the EC2 instance will be launched"
}

variable "security_group_id" {
  description = "The security group ID to associate with the EC2 instance"
}

variable "iam_instance_profile" {
  description = "IAM instance profile for CodeDeploy"
}


variable "subnet_id" {
  description = "The specific subnet ID where the EC2 instance will be launched"
}
