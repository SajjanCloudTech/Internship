variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  default = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_pair" {}

variable "s3_bucket_name" {
  default = "nodejs-artifact-bucket"
}

variable "security_group_id" {}

variable "iam_role_name" {}

variable "vpc_id" {}

variable "codestar_connection_arn" {
  description = "The ARN of the AWS CodeStar connection for GitHub"
}
