# modules/ecs/service/main.tf

# Target Group for ECS Service
resource "aws_lb_target_group" "ecs_target_group" {
  name        = "ecs-target-group"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  
  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    protocol            = "HTTP"
    matcher             = "200"
  }

  tags = var.tags
}

# ALB Listener
resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = var.alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}

# ECS Service resource
resource "aws_ecs_service" "service" {
  name            = "svc"
  cluster         = var.cluster
  task_definition = var.task_definition
  desired_count   = 1
  platform_version = "1.4.0"
  scheduling_strategy = "REPLICA"
  health_check_grace_period_seconds = 0
  enable_ecs_managed_tags = true
  propagate_tags = "NONE"
  enable_execute_command = false
  availability_zone_rebalancing = "ENABLED"

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 0
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  # Load balancer configuration
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = "app"
    container_port   = 3000
  }

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.ecs_task_security_group_id]
    # Change this to false if using private subnets with NAT gateway
    # If you're using public subnets but want to prevent direct access,
    # consider moving to private subnets with NAT gateway
    assign_public_ip = false
  }

  depends_on = [aws_lb_listener.ecs_alb_listener]

  tags = var.tags
}

# IAM Role for ECS Service
data "aws_iam_role" "ecs_service_role" {
  name = "AWSServiceRoleForECS"
}