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

# This output is useful for the autoscaling module
output "cluster_service_name_pair" {
  description = "The cluster name and service name joined with /"
  value       = "${var.cluster}/${aws_ecs_service.service.name}"
}