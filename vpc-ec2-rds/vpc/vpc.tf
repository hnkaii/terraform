# # #
#
# CONFIGURE VPC
#
resource "aws_vpc" "tf_vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
      "Name" = "${var.tag_name}-vpc"
    }
}
# # #
#
# CONFIGURE SUBNET
#
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
# # #
#
# CONFIGURE INTERNET GATEWAY
#
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.tf_vpc.id
    tags = {
      "Name" = "${var.tag_name}-igw"
    }
}
# # #
#
# CONFIGURE ROUTE TABLE
#
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
# # #
#
# CONFIGURE SECURITY GROUP
#
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