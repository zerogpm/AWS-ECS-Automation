# modules/autoscaling/outputs.tf

output "autoscaling_target_id" {
  description = "The autoscaling target ID"
  value       = aws_appautoscaling_target.ecs_target.id
}

output "alb_request_policy_arn" {
  description = "The ARN of the ALB request autoscaling policy"
  value       = var.enable_alb_request_scaling ? aws_appautoscaling_policy.ecs_alb_request_policy[0].arn : null
}

output "cpu_policy_arn" {
  description = "The ARN of the CPU autoscaling policy"
  value       = var.enable_cpu_scaling ? aws_appautoscaling_policy.ecs_cpu_policy[0].arn : null
}

output "memory_policy_arn" {
  description = "The ARN of the memory autoscaling policy"
  value       = var.enable_memory_scaling ? aws_appautoscaling_policy.ecs_memory_policy[0].arn : null
}

output "execution_role_name" {
  description = "The name of the IAM role used for task execution"
  value       = var.execution_role_name
}