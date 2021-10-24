# ------------------------------------------------------------#
#  VPC
# ------------------------------------------------------------#

resource "aws_vpc" "tf_vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
      "Name" = "${var.tag_name}-vpc"
    }
}
# Subnets 

resource "aws_subnet" "public_subnet_1a" {
    vpc_id = aws_vpc.tf_vpc.id
    cidr_block = var.public_subnet_1a
    availability_zone = var.az_1a
    map_customer_owned_ip_on_launch = true
    tags = {
      "Name" = "${var.tag_name}-public_subnet_1a"
    }
}
resource "aws_subnet" "private_subnet_1a" {
    vpc_id = aws_vpc.tf_vpc.id
    cidr_block = var.private_subnet_1a
    availability_zone = var.az_1a
    tags = {
      "Name" = "${var.tag_name}-private-subnet-1a"
    }
}
resource "aws_subnet" "private-subnet-1c" {
    vpc_id = aws_vpc.tf_vpc.id
    cidr_block = var.private_subnet_1c
    availability_zone = var.az_1c
    tags = {
      "Name" = "${var.tag_name}-private-subnet-1c"
    }
}
# Internet Gateway 

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.tf_vpc.id
    tags = {
      "Name" = "${var.tag_name}-igw"
    }
}
# Route Table 

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.tf_vpc.id
    route = [ {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    } ]
    tags = {
      "Name" = "${var.tag_name}-public-route-table"
    }
}
resource "aws_route_table_association" "public-route-table-association" {
    route_table_id = aws_route_table.public_route_table.id
    subnet_id = aws_subnet.public_subnet_1a.id
}
# Security Groups (SG) on EC2

resource "aws_security_group" "ec2_sg" {
    name = "ec2_sg"
    description = "SG on EC2 instance"
    vpc_id = aws_vpc.tf_vpc.id
    tags = {
      "Name" = "${var.tag_name}-ec2-sg"
    }
}
resource "aws_security_group_rule" "ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.ec2_sg.id
}
resource "aws_security_group_rule" "http" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.ec2_sg.id
}
resource "aws_security_group_rule" "https" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.ec2_sg.id
}
resource "aws_security_group_rule" "allow_outbound" {
    type = "egress"
    from_port = 0
    to_port = 0
    tcp = "-1"
    security_group_id = aws_security_group.ec2_sg.id
}

# Security Groups (SG) on RDS
resource "aws_security_group" "db_sg" {
  name        = "${var.tag_name}-db-sg"
  description = "Security Group on DB instance"
  vpc_id      = aws_vpc.tf_vpc.id
}
resource "aws_security_group_rule" "allowed_port" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2_sg.id
  security_group_id        = aws_security_group.db_sg.id
}
resource "aws_db_subnet_group" "db_sng" {
  name        = "${var.tag_name}-db_subnet-group"
  description = "DB subnet group on main vpc"
  subnet_ids  = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1c.id]
  tags = {
    "Name" = "${var.tag_name}-db-subnet"
  }
}
