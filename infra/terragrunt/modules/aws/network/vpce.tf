resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.private_a.id,
    aws_route_table.private_c.id,
    aws_route_table.public.id,
  ]

  tags = {
    Name = "${var.name_prefix}-vpce-${var.region_short_name}-s3"
  }
}
