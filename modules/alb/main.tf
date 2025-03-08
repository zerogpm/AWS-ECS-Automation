# Terraform AWS Application Load Balancer (ALB)
# modules/alb/main.tf
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.13.0"
  enable_deletion_protection = false
  # Add this line to disable automatic security group creation
  create_security_group = false
  name                       = "${var.name}-alb"
  load_balancer_type         = "application"
  vpc_id                     = var.vpc_id
  subnets                    = var.subnets
  security_groups            = var.security_groups
  # Listeners

  tags = var.tags # ALB Tags
}