module "vpc" {
  source = "../../modules/vpc"
  vpc_id = module.vpc.vpc_id
}

module "security" {
  source      = "../../modules/security"
  vpc_id      = module.vpc.vpc_id
  subnet_id   = module.vpc.subnet_id
  instance_id = module.ec2.instance_id
}

module "ec2" {
  source            = "../../modules/ec2"
  security_groups   = [module.security.security_group_id]
  security_group_id = module.security.security_group_id
  subnet_id         = module.vpc.subnet_id
  availability_zone = "us-east-2a"
  ami               = "ami-09ad6bca8b1dfb96b"
  instance_type     = "t2.micro"
}

resource "aws_dynamodb_table" "statelock" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}