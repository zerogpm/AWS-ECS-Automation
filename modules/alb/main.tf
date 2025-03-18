# modules/alb/main.tf
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.13.0"

  enable_deletion_protection = false
  create_security_group      = false

  name               = "${var.name}-alb"
  load_balancer_type = "application"
  vpc_id             = var.vpc_id
  subnets            = var.subnets
  security_groups    = var.security_groups

  # Listeners with modern syntax
  listeners = {
    http_80 = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "frontend"
      }
    }
  }

  # Target groups with modern syntax
  target_groups = {
    frontend = {
      name_prefix      = "front-"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "ip"

      health_check = {
        enabled             = true
        interval            = 30
        path                = var.health_check_path # Use variable for health check path
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200"
      }

      # Important: Don't create attachments - ECS will register the targets
      create_attachment = false
    }
  }

  tags = var.tags
}