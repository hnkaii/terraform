data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "public_subnet_1a" {
    default = "10.0.1.0/24"
}

variable "private_subnet_1a" {
    default = "10.0.2.0/24"
}

variable "private_subnet_1c" {
    default = "10.0.3.0/24"
}

variable "ec2_instance_type" {
    default = "t3.micro"
}

variable "az_1a" {
    default = "ap-northeast-1a"
}

variable "az_1c" {
    default = "ap-northeast-1c"
}

variable "tag_name" {
    default = "terraform"
}

variable "db_username" { # Read from .envrc
    type = String
}

variable "db_password" { # Read from .envrc
    type = String
}