output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = module.ecr.repository_arn
}

output "ecr_repository_url" {
  description = "URL of the ECR repository" 
  value       = module.ecr.repository_url
}