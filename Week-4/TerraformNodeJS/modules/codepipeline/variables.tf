variable "pipeline_role_arn" {}
variable "s3_bucket" {}
variable "codedeploy_app_name" {}
variable "codedeploy_group_name" {}

# GitHub Repository ID (e.g., "SajjanCloudTech/Internship")
variable "source_repo_id" {
  default = "SajjanCloudTech/Internship"
}

# Branch to track (e.g., "main")
variable "source_repo_branch" {
  default = "main"
}

# AWS CodeStar connection ARN (Passed from Root Module)
variable "codestar_connection_arn" {}


