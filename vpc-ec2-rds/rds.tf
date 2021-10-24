# ------------------------------------------------------------#
#  RDS
# ------------------------------------------------------------#
resource "aws_db_instance" "mysql" {
  identifier        = "${var.tag_name}-db"
  allocated_storage = 5
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"
  storage_type      = "gp2"

  publicly_accessible       = false
  multi_az                  = false
  backup_retention_period   = 1
  final_snapshot_identifier = "${var.tag_name}-db-snapshot"
  skip_final_snapshot       = true
  apply_immediately         = true

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_sng.name

  username = var.db_username
  password = var.db_password
}
