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
