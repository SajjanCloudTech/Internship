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

resource "aws_iam_role_policy_attachment" "codepipeline_admin_access" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


# IAM Role for CodePipeline
resource "aws_iam_role" "codepipeline_role" {
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
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

resource "aws_iam_policy" "codestar_policy" {
  name        = "CodePipeline-CodeStarConnections-Policy"
  description = "Grants permissions for AWS CodePipeline to use CodeStar Connections"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "codestar-connections:UseConnection",
        "Resource": "arn:aws:codeconnections:us-east-2:664418970145:connection/aea06f50-ba54-426b-ab21-7409a62b2a65"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "codepipeline_codestar_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codestar_policy.arn
}

resource "aws_iam_policy" "codepipeline_s3_policy" {
  name        = "CodePipeline-S3-Policy"
  description = "Allows AWS CodePipeline to upload artifacts to S3"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource": [
          "arn:aws:s3:::artifact-bucket-sajjan",
          "arn:aws:s3:::artifact-bucket-sajjan/*"
        ]
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "codepipeline_s3_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_s3_policy.arn
}

resource "aws_iam_policy" "codepipeline_codedeploy_policy" {
  name        = "CodePipeline-CodeDeploy-Policy"
  description = "Allows AWS CodePipeline to create deployments in AWS CodeDeploy"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "codedeploy:CreateDeployment",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:RegisterApplicationRevision"
        ],
        "Resource": "arn:aws:codedeploy:us-east-2:664418970145:deploymentgroup:NodeJSApp/NodeJSDeploymentGroup"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "codepipeline_codedeploy_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_codedeploy_policy.arn
}

resource "aws_iam_role" "codedeploy_ec2_role" {
  name = "CodeDeploy-EC2-Role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "codedeploy_ec2_role_attach" {
  role       = aws_iam_role.codedeploy_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "codedeploy_instance_profile" {
  name = "CodeDeployInstanceProfile"
  role = aws_iam_role.codedeploy_ec2_role.name
}


resource "aws_iam_policy" "codedeploy_s3_policy" {
  name        = "CodeDeploy-EC2-S3-Policy"
  description = "Allows EC2 instances to read deployment artifacts from S3"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource": [
          "arn:aws:s3:::artifact-bucket-sajjan",
          "arn:aws:s3:::artifact-bucket-sajjan/*"
        ]
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "codedeploy_s3_attach" {
  role       = aws_iam_role.codedeploy_ec2_role.name
  policy_arn = aws_iam_policy.codedeploy_s3_policy.arn
}
