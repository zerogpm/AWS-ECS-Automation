# modules/security/outputs.tf
output "loadbalancer_security_group_id" {
  description = "The ID of the Load Balancer Security Group"
  value       = module.loadbalancer_sg.security_group_id
}

output "ecs_task_security_group_id" {
  description = "The ID of the ECS task Security Group"
  value       = module.ecs_task_sg.security_group_id
}