# modules/security/main.tf

module "loadbalancer_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"
  
  name        = "loadbalancer-sg"
  description = "Security Group with HTTP open for entire Internet (IPv4 CIDR), egress ports are all world open"
  vpc_id      = var.vpc_id
  
  # Ingress Rules & CIDR Blocks
  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = var.tags
}

module "ecs_frontend_services_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"
  
  name        = "ecs-frontend-task-sg"  # Changed name to avoid conflict
  description = "Security Group with port 3000 open for ALB traffic only"
  vpc_id      = var.vpc_id
  
  # Only allow ingress from the ALB security group on port 3000
  ingress_with_source_security_group_id = [
    {
      from_port                = 3000
      to_port                  = 3000
      protocol                 = "tcp"
      description              = "Allow port 3000 from ALB only"
      source_security_group_id = module.loadbalancer_sg.security_group_id
    }
  ]
  
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = var.tags
}

module "ecs_backend_services_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"
  
  name        = "ecs-backend-task-sg"  # Changed name to avoid conflict
  description = "Security Group with port 5000 open for ALB and frontend traffic"
  vpc_id      = var.vpc_id
  
  # Allow traffic from ALB and frontend security group
  ingress_with_source_security_group_id = [
    {
      from_port                = 5000
      to_port                  = 5000
      protocol                 = "tcp"
      description              = "Allow port 5000 from ALB"
      source_security_group_id = module.loadbalancer_sg.security_group_id
    },
    {
      from_port                = 5000
      to_port                  = 5000
      protocol                 = "tcp"
      description              = "Allow port 5000 from frontend container"
      source_security_group_id = module.ecs_frontend_services_sg.security_group_id
    }
  ]
  
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = var.tags
}