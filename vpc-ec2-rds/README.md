## Desciption
A minimum setup of AWS VPC with a virtual machine EC2 and database RDS (Mysql 5.7) using Terraform. 

## Breakdown
1. VPC
  - A route table connects to Internet Gateway is associated with public subnet.
  - 2 private subnet, one is to host RDS instance, and the other one is to store log and backups.
  - 2 security groups, one is attached to EC2 instance (allow EC2 instance to connect to the Internet and allow https/http/ssh request to connect EC2), the other SG is for RDS instance which will allow connection from EC2 instance through port 3306.
2. EC
  - A key pair in order to ssh into EC2 instance with CLI
  - Elastic IP
  - Simple config of AMI
  - User data for EC2 instance to be able to connect to RDS instance on its initialization.
 3. RDS
  - DB subnet group.
  - Credentials for DB server.
