variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  default = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  default = "t2.micro"
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


variable "codestar_connection_arn" {
  description = "The ARN of the AWS CodeStar connection for GitHub"
  type        = string
}

variable "iam_role_name" {
  description = "The name of the IAM role to be used for EC2 and CodeDeploy"
  default     = "JenkinsEC2"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for storing artifacts"
  default     = "artifact-bucket-sajjan"
}

variable "subnet_id" {
  description = "The specific subnet ID where the EC2 instance will be launched"
  default     = "subnet-0cf37bc1ff077de06"
}
