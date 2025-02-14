# Creating EC2 Instance
resource "aws_instance" "sajjan_web_server" {
  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  subnet_id = var.subnet_id
  key_name          = "SajjanKeyPair"
  security_groups = [var.security_group_id]
  associate_public_ip_address = true
  user_data_replace_on_change = true

user_data = <<-EOF
   #!/bin/bash
   sudo yum update -y
   cd
   git clone https://github.com/jenkins-docs/simple-java-maven-app.git
   EOF


  tags = {
    Name = "Sajjan_Webserver"
    
  }

lifecycle {
  ignore_changes = [ 
    security_groups,
    
   ]
}
}

