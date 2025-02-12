

# IAM Module (Creates necessary IAM roles for EC2, CodePipeline, and CodeDeploy)
module "iam" {
  source        = "../../Week-4/TerraformNodeJS/modules/iam"
  iam_role_name = var.iam_role_name
}

# S3 Bucket Module (Stores CodePipeline artifacts)
module "s3" {
  source = "../../Week-4/TerraformNodeJS/modules/s3"
  # bucket_name = var.s3_bucket_name
  bucket_name = var.s3_bucket_name

}

# S3 Bucket Module (Stores CodeBuild artifacts)
module "s3_codebuild" {
  source      = "../../Week-4/TerraformNodeJS/modules/s3"
  bucket_name = "${var.s3_bucket_name}-build"
}

module "ec2" {
  source               = "../../Week-4/TerraformNodeJS/modules/ec2"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_pair             = var.key_pair
  vpc_id               = var.vpc_id
  subnet_id            = var.subnet_id
  security_group_id    = var.security_group_id
  iam_instance_profile = module.iam.codedeploy_instance_profile
}

# CodeDeploy Module (Manages deployment)
module "codedeploy" {
  source           = "../../Week-4/TerraformNodeJS/modules/codedeploy"
  service_role_arn = module.iam.service_role_arn
}

# CodePipeline Module (Manages CI/CD pipeline)
module "codepipeline" {
  source                  = "../../Week-4/TerraformNodeJS/modules/codepipeline"
  pipeline_role_arn       = module.iam.codepipeline_role_arn
  s3_bucket               = module.s3.s3_bucket_name
  codedeploy_app_name     = module.codedeploy.codedeploy_app_name
  codebuild_project_name  = module.codebuild.codebuild_project_name
  codedeploy_group_name   = "NodeJSDeploymentGroup"
  source_repo_id          = "SajjanCloudTech/Internship"
  source_repo_branch      = "main"
  codestar_connection_arn = var.codestar_connection_arn
}

module "ecr" {
  source        = "../../Week-4/TerraformNodeJS/modules/ecr"
  ecr_repo_name = "nodejs-todo-app"
}

module "codebuild" {
  source             = "../../Week-4/TerraformNodeJS/modules/codebuild"
  codebuild_role_arn = module.iam.codebuild_role_arn
  aws_region         = "us-east-1"
  ecr_repository_url = module.ecr.repository_url
  ecr_repo_name      = module.ecr.repository_name
  s3_bucket          = module.s3_codebuild.s3_bucket_name
}
