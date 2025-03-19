# modules/alb/outputs.tf

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.alb.dns_name
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = module.alb.arn
}

output "target_group_arns" {
  description = "ARNs of the target groups"
  value       = module.alb.target_groups
}

output "listener_arns" {
  description = "The ARNs of the listeners"
  value       = module.alb.listeners
}

# Frontend target group
output "frontend_target_group_arn" {
  description = "ARN of the frontend target group"
  value       = module.alb.target_groups["frontend"].arn
}

# Specific outputs needed for autoscaling
output "lb_arn_suffix" {
  description = "ARN suffix of the load balancer (needed for CloudWatch metrics and autoscaling)"
  value       = module.alb.arn_suffix
}

output "frontend_target_group_arn_suffix" {
  description = "ARN suffix of the frontend target group (needed for autoscaling)"
  value       = module.alb.target_groups["frontend"].arn_suffix
}