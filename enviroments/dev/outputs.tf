# ECR Repository outputs
output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = module.ecr.repository_arn
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

# ECS Cluster outputs
output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.ecs_cluster_name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = module.ecs.ecs_cluster_arn
}

output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = module.ecs.ecs_cluster_id
}

# Task definition outputs
output "frontend_task_definition_arn" {
  description = "The ARN of the frontend task definition"
  value       = module.frontend_task_definition.task_definition_arn
}

output "backend_task_definition_arn" {
  description = "The ARN of the backend task definition"
  value       = module.backend_task_definition.task_definition_arn
}

# ALB outputs
output "alb_arn" {
  description = "The ARN of the ALB"
  value       = module.loadbalancer.alb_arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.loadbalancer.alb_dns_name
}

output "frontend_target_group_arn" {
  description = "The ARN of the frontend target group"
  value       = module.loadbalancer.frontend_target_group_arn
}

# Service outputs
output "frontend_service_name" {
  description = "The name of the frontend ECS service"
  value       = module.frontend_service.service_name
}

output "backend_service_name" {
  description = "The name of the backend ECS service"
  value       = module.backend_service.service_name
}

output "backend_service_endpoint" {
  description = "The Service Connect endpoint for the backend service"
  value       = "${module.backend_service.service_name}.${aws_service_discovery_http_namespace.service_connect.name}"
}