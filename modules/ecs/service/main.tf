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
  enable_execute_command             = true
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
  
  # Add service discovery configuration conditionally
  dynamic "service_registries" {
    for_each = var.enable_service_discovery ? [1] : []
    content {
      registry_arn   = aws_service_discovery_service.this[0].arn
    }
  }
  
  # Load balancer configuration - only used if target_group_arn is provided
  dynamic "load_balancer" {
    for_each = var.target_group_arn != "" ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }
  
  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = false
  }
  
  tags = var.tags
}

# Cloud Map namespace (if create_namespace is true)
resource "aws_service_discovery_private_dns_namespace" "this" {
  count = var.enable_service_discovery && var.create_namespace ? 1 : 0
  
  name        = var.namespace_name
  description = var.namespace_description
  vpc         = var.vpc_id
  
  tags = var.tags
}

# Service Discovery Service
resource "aws_service_discovery_service" "this" {
  count = var.enable_service_discovery ? 1 : 0
  
  name        = coalesce(var.service_discovery_name, var.name)
  description = var.service_discovery_description
  
  # Use the created namespace ID if creating one, otherwise use the provided existing ID
  namespace_id = var.create_namespace ? aws_service_discovery_private_dns_namespace.this[0].id : var.existing_namespace_id

  dns_config {
    namespace_id = var.create_namespace ? aws_service_discovery_private_dns_namespace.this[0].id : var.existing_namespace_id
    
    dns_records {
      ttl  = var.dns_ttl
      type = "A"
    }
    
    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}



# IAM Role for ECS Service
data "aws_iam_role" "ecs_service_role" {
  name = "AWSServiceRoleForECS"
}