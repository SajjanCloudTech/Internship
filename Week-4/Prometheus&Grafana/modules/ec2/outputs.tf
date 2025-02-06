output "ec2_public_ip" {
  value = aws_instance.pg_server.public_ip
}
