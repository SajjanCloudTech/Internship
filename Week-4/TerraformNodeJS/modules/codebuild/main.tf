resource "aws_codebuild_project" "nodejs_build" {
  name          = "NodeJS-Build"
  description   = "Builds and pushes the Node.js Docker image to ECR"
  service_role  = var.codebuild_role_arn
  build_timeout = "10"

  artifacts {
    type     = "CODEPIPELINE"
    location = var.s3_bucket
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true  # Required for Docker builds

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }
    environment_variable {
      name  = "ECR_REPOSITORY_URL"
      value = var.ecr_repository_url
    }
    environment_variable {
      name  = "ECR_REPO_NAME"
      value = var.ecr_repo_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}
