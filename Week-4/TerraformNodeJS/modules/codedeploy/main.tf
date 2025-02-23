resource "aws_codedeploy_app" "nodejs_app" {
  name = "NodeJSApp"
}

resource "aws_codedeploy_deployment_group" "nodejs_group" {
  app_name              = aws_codedeploy_app.nodejs_app.name
  deployment_group_name = "NodeJSDeploymentGroup"
  service_role_arn      = var.service_role_arn  

    ec2_tag_set {
    ec2_tag_filter {
      key   = "Environment"
      type  = "KEY_AND_VALUE"
      value = "Production"
      }
  }
}

