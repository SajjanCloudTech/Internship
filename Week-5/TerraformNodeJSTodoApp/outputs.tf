output "ec2_public_ip" {
  value = module.ec2.ec2_public_ip
}

output "s3_bucket_name" {
  value = module.s3.s3_bucket_name
}

output "codedeploy_app_name" {
  value = module.codedeploy.codedeploy_app_name
}

output "pipeline_name" {
  value = module.codepipeline.pipeline_name
}

# output "ecr_url" {
#   value = module.ecr.ecr_repository_url
# }

# output "ecr_arn" {
#   value = module.ecr.ecr_repository_arn
# }

output "codebuild_project_name" {
  value = module.codebuild.codebuild_project_name
}
