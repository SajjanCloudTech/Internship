
# Create Security Group
module "security_group" {
  source = "../../modules/security_group"
  vpc_id = var.vpc_id.id
}

# Create IAM Roles
module "iam" {
  source = "../../modules/iam"
  iam_role_name = var.iam_role_name.i
}

# Create S3 Bucket for Artifacts
module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.s3_bucket_name
}

# Launch EC2 instance for Node.js apps
module "ec2" {
  source               = "../../modules/ec2"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_pair             = var.key_pair
  security_group_id    = module.security_group.security_group_id
  iam_instance_profile = module.iam.iam_instance_profile
}

# Create CodeDeploy App & Deployment Group
module "codedeploy" {
  source           = "../../modules/codedeploy"
  service_role_arn = module.iam.iam_instance_profile
}

# Create CodePipeline for Continuous Deployment
module "codepipeline" {
  source                = "./modules/codepipeline"
  pipeline_role_arn     = module.iam.pipeline_role_arn
  s3_bucket             = module.s3.s3_bucket_name
  codedeploy_app_name   = module.codedeploy.codedeploy_app_name
  codedeploy_group_name = "NodeJSDeploymentGroup"
  source_repo_id        = "SajjanCloudTech/Internship"
  source_repo_branch    = "main"
  codestar_connection_arn = var.codestar_connection_arn
}
