output "ecr_depends_on" {
  value       = terraform_data.build_openmetadata_image.id
  description = "value of the ecr depends on for the ecs"
}