#environments/dev/

# output "ecr_repository_arn" {
#   description = "ARN of the ECR repository"
#   value       = module.ecr.repository_arn
# }

# output "ecr_repository_url" {
#   description = "URL of the ECR repository" 
#   value       = module.ecr.repository_url
# }

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