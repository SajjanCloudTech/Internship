# IAM Role for EC2 Instance Profile
resource "aws_iam_role" "ec2_role" {
  name = "ec2-codedeploy-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  }
  EOF
}

# Attach Policies to EC2 Role
resource "aws_iam_role_policy_attachment" "ec2_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Create Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-codedeploy-profile"
  role = aws_iam_role.ec2_role.name
}

# IAM Role for CodeDeploy
resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy-service-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "codedeploy.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "codedeploy_attach" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

# IAM Role for CodePipeline
resource "aws_iam_role" "pipeline_role" {
  name = "codepipeline-service-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "codepipeline.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "pipeline_attach" {
  role       = aws_iam_role.pipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

# resource "aws_iam_policy" "codestar_policy" {
#   name        = "CodePipeline-CodeStarConnections-Policy"
#   description = "Grants permissions for AWS CodePipeline to use CodeStar Connections"

#   policy = <<EOF
#   {
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Action": "codestar-connections:UseConnection",
#         "Resource": "arn:aws:codeconnections:us-east-2:664418970145:connection/aea06f50-ba54-426b-ab21-7409a62b2a65"
#       }
#     ]
#   }
#   EOF
# }

# resource "aws_iam_role_policy_attachment" "codepipeline_codestar_attach" {
#   role       = aws_iam_role.codepipeline_role.name
#   policy_arn = aws_iam_policy.codestar_policy.arn
# }
