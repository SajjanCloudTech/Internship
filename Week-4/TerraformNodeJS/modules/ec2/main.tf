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
  sudo apt update -y
  sudo apt install -y nodejs npm
  sudo apt install -y ruby
  sudo apt install -y awscli


  cd /home/ubuntu
  wget https://bucket-name.s3.region-identifier.amazonaws.com/latest/install
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
