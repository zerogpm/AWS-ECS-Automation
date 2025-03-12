# modules/security/outputs.tf
output "loadbalancer_security_group_id" {
  description = "The ID of the ALB security group"
  value       = module.loadbalancer_sg.security_group_id
}

output "frontend_security_group_id" {
  description = "The ID of the frontend task security group"
  value       = module.ecs_frontend_services_sg.security_group_id
}

output "backend_security_group_id" {
  description = "The ID of the backend task security group"
  value       = module.ecs_backend_services_sg.security_group_id
}