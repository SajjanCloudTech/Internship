output "codebuild_project_name" {
  description = "AWS CodeBuild Project Name"
  value       = aws_codebuild_project.nodejs_build.name
}
