# modules/ecs/serive/outputs.tf

output "service_id" {
  description = "The ID of the ECS service"
  value       = aws_ecs_service.service.id
}

output "service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.service.name
}

output "service_arn" {
  description = "The ARN of the ECS service"
  value       = aws_ecs_service.service.id
}

output "task_definition" {
  description = "The task definition used by the service"
  value       = aws_ecs_service.service.task_definition
}

output "namespace_arn" {
  description = "The ARN of the created Cloud Map namespace (if any)"
  value       = var.enable_service_discovery && var.create_namespace ? aws_service_discovery_private_dns_namespace.this[0].arn : ""
}

output "namespace_id" {
  description = "The ID of the created Cloud Map namespace (if any)"
  value       = var.enable_service_discovery && var.create_namespace ? aws_service_discovery_private_dns_namespace.this[0].id : ""
}

output "namespace_name" {
  description = "The name of the created Cloud Map namespace (if any)"
  value       = var.enable_service_discovery && var.create_namespace ? aws_service_discovery_private_dns_namespace.this[0].name : ""
}

output "service_discovery_service_arn" {
  description = "The ARN of the service discovery service"
  value       = var.enable_service_discovery ? aws_service_discovery_service.this[0].arn : ""
}

output "service_discovery_service_id" {
  description = "The ID of the service discovery service"
  value       = var.enable_service_discovery ? aws_service_discovery_service.this[0].id : ""
}