resource "aws_instance" "pg_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true

user_data = <<-EOF
  #!/bin/bash
  set -e

  echo "Starting setup on Amazon Linux 2 as root..." | tee /var/log/user-data.log

  # Update system and install required packages
  echo "Updating packages..." | tee -a /var/log/user-data.log
  sudo yum update -y
  sudo yum install -y docker

  # Start and enable Docker
  echo "Starting Docker service..." | tee -a /var/log/user-data.log
  sudo systemctl enable --now docker

  # Add ec2-user to the docker group (optional: avoids needing sudo for Docker commands)
  sudo usermod -aG docker ec2-user

  # Install Docker Compose
  echo "Installing Docker Compose..." | tee -a /var/log/user-data.log
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
  sudo docker-compose --version | tee -a /var/log/user-data.log

  # Set up directories
  echo "Setting up directories..." | tee -a /var/log/user-data.log
  sudo mkdir -p /opt/prometheus/config /opt/prometheus/data
  cd /opt/prometheus

  # Create docker-compose.yml
  echo "Creating docker-compose.yml..." | tee -a /var/log/user-data.log
  sudo tee docker-compose.yml > /dev/null <<EOF1
  volumes:
    prometheus-data:
      driver: local
    grafana-data:
      driver: local
  services:
    prometheus:
      image: prom/prometheus:latest
      container_name: prometheus
      restart: unless-stopped
      volumes:
        - ./config:/etc/prometheus/
        - prometheus-data:/prometheus
      networks:
        - prometheus-network
      ports:
        - "9090:9090"
    grafana:
      image: grafana/grafana:latest
      container_name: grafana
      restart: unless-stopped
      volumes:
        - grafana-data:/var/lib/grafana
      networks:
        - prometheus-network
      ports:
        - "3000:3000"
    node_exporter:
      image: quay.io/prometheus/node-exporter:latest
      container_name: node_exporter
      command:
        - '--path.rootfs=/host'
      pid: host
      ports:
        - "9100:9100"
      restart: unless-stopped
      volumes:
        - '/:/host:ro,rslave'
      networks:
        - prometheus-network
  networks:
    prometheus-network:
      driver: bridge
  EOF1

  # Create Prometheus configuration file
  echo "Creating Prometheus config file..." | tee -a /var/log/user-data.log
  sudo tee config/prometheus.yml > /dev/null <<EOF2
  global:
    scrape_interval: 15s
    external_labels:
      monitor: 'codelab-monitor'
  scrape_configs:
    - job_name: 'prometheus'
      static_configs:
        - targets: ['prometheus:9090']
    - job_name: 'node_exporter'
      static_configs:
        - targets: ['node_exporter:9100']
  EOF2

  # Start services
  echo "Starting Docker Compose services..." | tee -a /var/log/user-data.log
  sudo docker-compose up -d | tee -a /var/log/user-data.log

  # Ensure services start on reboot
  echo "@reboot root (cd /opt/prometheus && sudo docker-compose up -d)" | sudo tee -a /etc/crontab

  echo "Setup completed successfully as root!" | tee -a /var/log/user-data.log
EOF


  tags = {
    Name        = "Prometheus&Grafana"
    Environment = "Development"
  }
}
