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
 
  # Install Ruby (Required for AWS CodeDeploy agent)
  sudo yum install -y ruby

 # Install Docker
  echo "Installing Docker..."
  sudo amazon-linux-extras enable docker
  sudo yum install -y docker
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker ec2-user  # Allow ec2-user to use Docker without sudo

 # Ensure correct permissions for deployment scripts
  echo "Setting permissions..."
  sudo chmod +x /home/ec2-user/todoapp/scripts/docker.sh

  # Install and Start AWS CodeDeploy Agent
  cd /home/ec2-user
  sudo wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install
  sudo chmod +x ./install
  sudo ./install auto
  sudo systemctl start codedeploy-agent
  sudo systemctl enable codedeploy-agent
EOF


  tags = {
    Name        = "NodeJSAppInstance"
    Environment = "Production"
  }
}
