# -------------------------- Keypair --------------------------#
resource "aws_key_pair" "ec2_kp" {
  key_name   = "${var.tag_name}-kp"
  public_key = file("key/${var.tag_name}-kp.pub")
  tags = {
    "Name" = "${var.tag_name}-kp"
  }
}
data "template_file" "user_data" {
  template = file("templates/user_data.tpl")
}
# -------------------------- EC2 --------------------------#
resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.ec2_instance_type
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  subnet_id                   = aws_subnet.public_subnet_1a.id
  key_name                    = aws_key_pair.ec2_kp.key_name
  associate_public_ip_address = true
  root_block_device {
    volume_type = "gp3"
    volume_size = "20"
  }
  tags = {
    "Name" = "${var.tag_name}-ec2"
  }
# -------------------------- Install MySQL Client --------------------------#
  user_data = data.template_file.user_data.rendered
}
# -------------------------- Elastic IP --------------------------#
resource "aws_eip" "ec2_eip" {
  instance = aws_instance.ec2.id
  vpc      = true
}