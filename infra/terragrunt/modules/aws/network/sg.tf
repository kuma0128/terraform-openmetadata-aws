# defaultデフォルトのsgからingress,egressを削除
resource "aws_default_security_group" "sg_default" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-sg-default"
  }
}

resource "aws_security_group" "self_reference" {
  vpc_id      = aws_vpc.this.id
  name        = "${var.name_prefix}-sg-self-reference"
  description = "self-reference"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all traffic from self"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_vpc]
    description = "Allow all outbound traffic to self"
  }

  tags = {
    Name = "${var.name_prefix}-sg-self-reference"
  }
}
