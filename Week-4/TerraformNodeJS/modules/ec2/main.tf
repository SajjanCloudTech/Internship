


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
  sudo yum update -y
  sudo amazon-linux-extras enable nodejs14
  sudo yum install -y nodejs
  sudo mkdir -p /var/www/app1 /var/www/app2
  sudo chown -R ec2-user:ec2-user /var/www
  EOF

  tags = {
    Name = "NodeJS-EC2-Server"
  }
}
