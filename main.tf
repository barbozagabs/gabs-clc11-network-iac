### CREATE VPC ##
resource "aws_vpc" "vpc_network" {
  cidr_block       = var.vpc_range
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name
  }
}

### ADICIONANDO LOG PARA VPC ###
resource "aws_flow_log" "flow_log" {
  log_destination      = "arn:aws:s3:::gabs-clc11-tfstatee"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.minha_vpc.id
}

### ADICIONANDO SECURITY GROUP SEPARADAMENTE ###
#resource "aws_default_security_group" "default" {
#  vpc_id = aws_vpc.issue_vpc.id
#  ingress {
#    protocol  = "-1"
#    self      = true
#    from_port = 0
#    to_port   = 0
#  }
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = var.vpc_range
#  }
#}

### CREATE SUBNET PUBLIC E PRIVADA 1A ##
resource "aws_subnet" "subnet_privada_1a" {
  vpc_id            = aws_vpc.vpc_network.id
  cidr_block        = var.subnet_privada_1a_range
  availability_zone = var.availability_zone_1a
  tags = {
    Name = "iac_subnet_privada_1a"
  }
}

resource "aws_subnet" "subnet_publica_1a" {
  vpc_id            = aws_vpc.vpc_network.id
  cidr_block        = var.subnet_publica_1a_range
  availability_zone = var.availability_zone_1a
  tags = {
    Name = "iac_subnet_publica_1a"
  }
}

### CREATE SUBNET PUBLIC E PRIVADA 1C ##
resource "aws_subnet" "subnet_privada_1c" {
  vpc_id            = aws_vpc.vpc_network.id
  cidr_block        = var.subnet_privada_1c_range
  availability_zone = var.availability_zone_1c
  tags = {
    Name = "iac_subnet_privada_1c"
  }
}

resource "aws_subnet" "subnet_publica_1c" {
  vpc_id            = aws_vpc.vpc_network.id
  cidr_block        = var.subnet_publica_1c_range
  availability_zone = var.availability_zone_1c
  tags = {
    Name = "iac_subnet_publica_1c"
  }
}

### CREATE INTERNET GATEWAY ### 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_network.id

  tags = {
    Name = var.internet_gatewy
  }
}

### CREATE ROUTE TABLE ### 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "iac_public_rt"
  }
}

### ASSOCIATION ROUTE TABLE ### 
resource "aws_route_table_association" "public-1a" {
  subnet_id      = aws_subnet.subnet_publica_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public-1c" {
  subnet_id      = aws_subnet.subnet_publica_1c.id
  route_table_id = aws_route_table.public_rt.id
}


### CREATE IP PUBLICO 1A ###
resource "aws_eip" "ip_nat_1a"{
    domain = "vpc"
}

### NAT GATEWAY 1A ###
resource "aws_nat_gateway" "natgateway_1a" {
  allocation_id = aws_eip.ip_nat_1a.id
  subnet_id     = aws_subnet.subnet_publica_1a.id

  tags = {
    Name = "iac-natgatway-1a"
  }
}
  
### CREATE IP PUBLICO 1C ###
resource "aws_eip" "ip_nat_1c"{
    domain = "vpc"
} 

### NAT GATEWAY 1C ###
resource "aws_nat_gateway" "natgateway_1c" {
  allocation_id = aws_eip.ip_nat_1c.id
  subnet_id     = aws_subnet.subnet_publica_1c.id

  tags = {
    Name = "iac-natgatway-1c"
  }
}

### CREATE ROUTE TABLE PRIVADA 1A ###
resource "aws_route_table" "private_rt_1a" {
  vpc_id = aws_vpc.vpc_network.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_1a.id
  }
  tags = {
    Name = "iac_private_rt_1a"
  }
}

### CREATE ROUTE TABLE PUBLICA 1C ###
resource "aws_route_table" "private_rt_1c" {
  vpc_id = aws_vpc.vpc_network.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_1c.id
  }
  tags = {
    Name = "iac_private_rt_1c"
  }
}

### ASSOCIATION ROUTE TABLE PRIVADA ### 
resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.subnet_privada_1a.id
  route_table_id = aws_route_table.private_rt_1a.id
}

resource "aws_route_table_association" "private-1c" {
  subnet_id      = aws_subnet.subnet_privada_1c.id
  route_table_id = aws_route_table.private_rt_1c.id
}