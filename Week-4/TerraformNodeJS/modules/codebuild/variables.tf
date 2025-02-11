variable "codebuild_role_arn" {
  description = "IAM Role ARN for CodeBuild"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket for storing pipeline artifacts"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL for storing Docker images"
  type        = string
}

variable "ecr_repo_name" {
  description = "ECR repository name"
  type        = string
}
