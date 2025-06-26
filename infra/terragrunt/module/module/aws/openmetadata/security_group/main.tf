resource "aws_security_group" "aurora_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg-${var.region_short_name}-aurora"
  }
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 8585
    to_port         = 8585
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg-${var.region_short_name}-ecs"
  }
}

resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = [aws_ec2_managed_prefix_list.allowed_ip_list.id]
    description     = ""
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg-${var.region_short_name}-alb"
  }
}

resource "aws_ec2_managed_prefix_list" "allowed_ip_list" {
  name           = "allowed_ip_list"
  address_family = "IPv4"
  max_entries    = 30

  dynamic "entry" {
    for_each = var.allowed_ip_list
    content {
      cidr        = entry.value
      description = ""
    }
  }
}