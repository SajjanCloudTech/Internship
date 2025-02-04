output "iam_instance_profile" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "codedeploy_role_arn" {
  value = aws_iam_role.codedeploy_role.arn
}

output "pipeline_role_arn" {
  value = aws_iam_role.pipeline_role.arn
}

output "service_role_arn" {
  value = aws_iam_role.codedeploy_role.arn
}
