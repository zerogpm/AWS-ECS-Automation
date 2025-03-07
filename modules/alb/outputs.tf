#modules/alb/outputs.tf

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.alb.dns_name
}

output "alb_arn" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.alb.arn
}