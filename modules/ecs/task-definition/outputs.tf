# modules/ecs/task-definition/outputs.tf

output "task_definition_arn" {
  description = "The ARN of the frontend task definition"
  value       = aws_ecs_task_definition.tip_task_definition.arn
}

output "task_definition_family" {
  description = "The family of the frontend task definition"
  value       = aws_ecs_task_definition.tip_task_definition.family
}

output "task_definition_revision" {
  description = "The revision of the frontend task definition"
  value       = aws_ecs_task_definition.tip_task_definition.revision
}