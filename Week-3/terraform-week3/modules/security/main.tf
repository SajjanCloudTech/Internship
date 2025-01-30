# Creating Security Group
resource "aws_security_group" "allow_webtraffic" {
  name        = "allow_webtraffic"
  description = "Allow web traffic."
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_webtraffic"

  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_webtraffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_webtraffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_webtraffic.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_webtraffic.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Creating Network Interface
resource "aws_network_interface" "NIC" {
  subnet_id       = var.subnet_id
  private_ips     = ["10.0.1.50"]
  security_groups = aws_security_group.allow_webtraffic.id

}

# Creating and assigning Elastic IP
resource "aws_eip" "eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.NIC.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.IGW]
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = var.instance_id
  allocation_id = aws_eip.eip.id
 }

# Creating Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Sajjan_IGW"

  }
}
resource "aws_egress_only_internet_gateway" "EIGW" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Sajjan_EIGW"

  }
}

# Creating Route Table
resource "aws_route_table" "Route_Table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.EIGW.id
  }

  tags = {
    Name = "Sajjan_RT"
   
  }
}

# Associating subnet with Route Table
resource "aws_route_table_association" "associate" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.Route_Table.id
}
