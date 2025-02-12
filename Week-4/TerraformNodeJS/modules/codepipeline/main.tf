resource "aws_codepipeline" "nodejs_pipeline" {
  name     = "NodeJS-Pipeline"
  role_arn = var.pipeline_role_arn
  pipeline_type = "V2"

  artifact_store {
    location = var.s3_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceOutput"]

      configuration = {
        ConnectionArn    = var.codestar_connection_arn  
        FullRepositoryId = var.source_repo_id
        BranchName       = var.source_repo_branch
      }
    }
  }

stage {
    name = "Approval"

    action {
      name             = "ManualApproval"
      category         = "Approval"
      owner            = "AWS"
      provider         = "Manual"
      version          = "1"
      input_artifacts  = []
      output_artifacts = []

      configuration = {
        NotificationArn   = "arn:aws:sns:us-east-2:664418970145:Manual-Approve"
        # ExternalEntityLink = "http://example.com"
        CustomData        = "The latest changes include feedback from Bob."
      }

      run_order = 1
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]
      version          = "1"

      configuration = {
        ProjectName = "NodeJS-Build"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name              = "Deploy"
      category          = "Deploy"
      owner             = "AWS"
      provider          = "CodeDeploy"
      input_artifacts   = ["SourceOutput"]
      version           = "1"

      configuration = {
        ApplicationName     = var.codedeploy_app_name
        DeploymentGroupName = var.codedeploy_group_name
      }
    }
  }

  execution_mode = "QUEUED"
}
