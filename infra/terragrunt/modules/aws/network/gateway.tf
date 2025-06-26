resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-igw-${var.region_short_name}"
  }
}

resource "aws_nat_gateway" "public_a" {
  subnet_id     = aws_subnet.public_a.id
  allocation_id = aws_eip.nat_a.allocation_id

  tags = {
    Name = "${var.name_prefix}-nat-${var.region_short_name}-public-a"
  }
}

resource "aws_nat_gateway" "public_c" {
  subnet_id     = aws_subnet.public_c.id
  allocation_id = aws_eip.nat_c.allocation_id

  tags = {
    Name = "${var.name_prefix}-nat-${var.region_short_name}-public-c"
  }
}

resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = {
    Name = "${var.name_prefix}-eip-${var.region_short_name}-nat-a"
  }
}

resource "aws_eip" "nat_c" {
  domain = "vpc"

  tags = {
    Name = "${var.name_prefix}-eip-${var.region_short_name}-nat-c"
  }
}