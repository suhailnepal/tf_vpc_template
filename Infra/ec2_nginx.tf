resource "aws_instance" "nginx_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.vpc.private_subnets[0]
  #key_name      = var.key_pair
  security_groups = [aws_security_group.instance_sg.id]
  lifecycle {
    ignore_changes = [
      security_groups,
    ]
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "${var.env}-sg"
  description = "Security group for instance"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "instance_443" {
  security_group_id        = aws_security_group.instance_sg.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  type                     = "ingress"
  source_security_group_id = aws_security_group.lb_sg.id
}

output "instanceid" {
  value = aws_instance.nginx_server.id
}