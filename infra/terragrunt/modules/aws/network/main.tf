resource "aws_vpc" "this" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name_prefix}-vpc-${var.region_short_name}"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.cidr_subnets_public[0]
  availability_zone = var.az_a_name

  tags = {
    Name = "${var.name_prefix}-subnet-${var.region_short_name}-public-a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.cidr_subnets_public[1]
  availability_zone = var.az_c_name

  tags = {
    Name = "${var.name_prefix}-subnet-${var.region_short_name}-public-c"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.cidr_subnets_private[0]
  availability_zone = var.az_a_name

  tags = {
    Name = "${var.name_prefix}-subnet-${var.region_short_name}-private-a"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.cidr_subnets_private[1]
  availability_zone = var.az_c_name

  tags = {
    Name = "${var.name_prefix}-subnet-${var.region_short_name}-private-c"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.this.default_route_table_id
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_a.id
  }

  tags = {
    Name = "${var.name_prefix}-rtb-${var.region_short_name}-private-a"
  }
}

resource "aws_route_table" "private_c" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_c.id
  }

  tags = {
    Name = "${var.name_prefix}-rtb-${var.region_short_name}-private-c"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.name_prefix}-rtb-${var.region_short_name}-public"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private_c.id
}
