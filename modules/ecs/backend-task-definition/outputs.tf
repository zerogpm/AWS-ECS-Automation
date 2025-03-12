# modules/ecs/backend-task-definition/outputs.tf
output "task_definition_arn" {
  description = "The ARN of the backend task definition"
  value       = aws_ecs_task_definition.backend_task.arn
}

output "task_definition_family" {
  description = "The family of the backend task definition"
  value       = aws_ecs_task_definition.backend_task.family
}

output "task_definition_revision" {
  description = "The revision of the backend task definition"
  value       = aws_ecs_task_definition.backend_task.revision
}