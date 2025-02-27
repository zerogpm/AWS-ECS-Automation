output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.this.name
}

output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.this.id
}

output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = aws_ecs_cluster.this.arn
}

output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.this.name
}