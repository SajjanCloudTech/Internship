resource "aws_instance" "nodejs_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_instance_profile
  associate_public_ip_address = true

user_data = <<-EOF
  #!/bin/bash
  # Update system packages
  sudo yum update -y

  # Install Node.js and npm (Amazon Linux 2)
  sudo amazon-linux-extras enable epel
  sudo amazon-linux-extras enable nodejs14
  sudo yum install -y nodejs npm
  
  # Install Ruby (Required for AWS CodeDeploy agent)
  sudo yum install -y ruby
  
  # Install AWS CLI
  sudo yum install -y aws-cli
  
  # Install Nginx
  sudo amazon-linux-extras enable nginx1
  sudo yum install -y nginx
  sudo systemctl start nginx
  sudo systemctl enable nginx

  # Install PM2 (Process Manager for Node.js)
  sudo npm install -g pm2
  pm2 startup systemd -u ec2-user --hp /home/ec2-user
  pm2 save

  # Install and Start AWS CodeDeploy Agent
  cd /home/ec2-user
  https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install
  chmod +x ./install
  sudo ./install auto
  sudo systemctl start codedeploy-agent
  sudo systemctl enable codedeploy-agent
EOF



  tags = {
    Name        = "NodeJSAppInstance"
    Environment = "Production"
  }
}
