# modules/ecs/service/main.tf

# ECS Service resource
resource "aws_ecs_service" "service" {
  name                               = var.name
  cluster                            = var.cluster
  task_definition                    = var.task_definition
  desired_count                      = var.desired_count
  platform_version                   = "1.4.0"
  scheduling_strategy                = "REPLICA"
  health_check_grace_period_seconds  = 0  # Set to 0 since we're not using a load balancer
  enable_ecs_managed_tags            = true
  propagate_tags                     = "NONE"
  enable_execute_command             = false
  availability_zone_rebalancing      = "ENABLED"
  
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
  
  # No load balancer configuration
  
  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = false
  }
  
  tags = var.tags
}

# IAM Role for ECS Service
data "aws_iam_role" "ecs_service_role" {
  name = "AWSServiceRoleForECS"
}