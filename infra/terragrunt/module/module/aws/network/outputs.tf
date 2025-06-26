output "subnet_a_public_id" {
  value       = aws_subnet.public_a.id
  description = "value of the subnet a public id"
}

output "subnet_c_public_id" {
  value       = aws_subnet.public_c.id
  description = "value of the subnet c public id"
}

output "subnet_a_private_id" {
  value       = aws_subnet.private_a.id
  description = "value of the subnet a private id"
}

output "subnet_c_private_id" {
  value       = aws_subnet.private_c.id
  description = "value of the subnet c private id"
}

output "vpc_id" {
  value       = aws_vpc.this.id
  description = "value of the vpc id"
}

output "s3_gateway_endpoint_id" {
  value       = aws_vpc_endpoint.s3.id
  description = "value of the s3 gateway endpoint id"
}