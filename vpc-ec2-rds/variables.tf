variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "public_subnet_1a" {
    default = "10.0.1.0/24"
}

variable "private_subnet_1a" {
    default = "10.0.2.0/24"
}

variable "public_subnet_1c" {
    default = "10.0.32.0/24"
}

variable "private_subnet_1c" {
    default = "10.0.33.0/24"
}

variable "ec2_instance_type" {
    default = "t2.micro"
}

variable "tag_name" {
    default = "terraform"
}

