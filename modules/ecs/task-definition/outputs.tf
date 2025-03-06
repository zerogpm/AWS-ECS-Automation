# /modules/ecr/task-definition/outputs.tf

# Output the task definition ARN and revision for use in aws_ecs_service
output "task_definition_arn" {
  description = "The ARN of the task definition"
  value       = aws_ecs_task_definition.app_task.arn
}

output "task_definition_family" {
  description = "The family of the task definition"
  value       = aws_ecs_task_definition.app_task.family
}

output "task_definition_revision" {
  description = "The revision of the task definition"
  value       = aws_ecs_task_definition.app_task.revision
}