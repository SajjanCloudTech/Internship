

# IAM Module (Creates necessary IAM roles for EC2, CodePipeline, and CodeDeploy)
module "iam" {
  source        = "../../modules/iam"
  iam_role_name = var.iam_role_name
}

# S3 Bucket Module (Stores CodePipeline artifacts)
module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.s3_bucket_name
}

module "ec2" {
  source               = "../../modules/ec2"
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
  source           = "../../modules/codedeploy"
  service_role_arn = module.iam.service_role_arn
}

# CodePipeline Module (Manages CI/CD pipeline)
module "codepipeline" {
  source                  = "../../modules/codepipeline"
  pipeline_role_arn       = module.iam.codepipeline_role_arn
  s3_bucket               = module.s3.s3_bucket_name
  codedeploy_app_name     = module.codedeploy.codedeploy_app_name
  codedeploy_group_name   = "NodeJSDeploymentGroup"
  source_repo_id          = "SajjanCloudTech/Internship"
  source_repo_branch      = "main"
  codestar_connection_arn = var.codestar_connection_arn
}