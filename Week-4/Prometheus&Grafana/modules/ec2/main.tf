resource "aws_instance" "pg_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true

## User Data is not working, so we need to configure these configuration ourselves
user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y docker

  sudo systemctl enable --now docker

  sudo usermod -aG docker ec2-user

  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
  sudo docker-compose --version | tee -a /var/log/user-data.log

  sudo mkdir -p /prometheus/config 


  sudo tee docker-compose.yml > /prometheus <<EOF1
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

  sudo tee config/prometheus.yml > /prometheus/config <<EOF2
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.

  # scrape_timeout is set to the global default (10s).
  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
      monitor: 'codelab-monitor'
# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['prometheus:9090']
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['node_exporter:9100']
  EOF2

  sudo docker-compose up -d 

EOF


  tags = {
    Name        = "Prometheus&Grafana"
    Environment = "Development"
  }
}
