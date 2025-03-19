# modules/autoscaling/main.tf

# Register a scalable target (the ECS service)
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  # AWS will use the service-linked role automatically
}

# ALB request count based scaling policy (useful for frontend services)
resource "aws_appautoscaling_policy" "ecs_alb_request_policy" {
  count = var.enable_alb_request_scaling ? 1 : 0

  name               = "${var.name}-alb-request-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${var.alb_arn_suffix}/${var.target_group_arn_suffix}"
    }

    # Target value is the desired request count per target
    target_value = var.target_request_count

    # Optional settings for fine-tuning scaling behavior
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown

    # Disable scale-in to avoid frequently removing instances (optional)
    disable_scale_in = var.disable_scale_in
  }
}

# CPU-based scaling policy (useful for compute-intensive workloads)
resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
  count = var.enable_cpu_scaling ? 1 : 0

  name               = "${var.name}-cpu-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    # Target value is the desired CPU utilization percentage
    target_value = var.target_cpu_utilization

    # Optional settings for fine-tuning scaling behavior
    scale_in_cooldown  = var.cpu_scale_in_cooldown != null ? var.cpu_scale_in_cooldown : var.scale_in_cooldown
    scale_out_cooldown = var.cpu_scale_out_cooldown != null ? var.cpu_scale_out_cooldown : var.scale_out_cooldown

    # Disable scale-in to avoid frequently removing instances (optional)
    disable_scale_in = var.cpu_disable_scale_in != null ? var.cpu_disable_scale_in : var.disable_scale_in
  }
}

# Memory-based scaling policy (useful for memory-intensive workloads)
resource "aws_appautoscaling_policy" "ecs_memory_policy" {
  count = var.enable_memory_scaling ? 1 : 0

  name               = "${var.name}-memory-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    # Target value is the desired memory utilization percentage
    target_value = var.target_memory_utilization

    # Optional settings for fine-tuning scaling behavior
    scale_in_cooldown  = var.memory_scale_in_cooldown != null ? var.memory_scale_in_cooldown : var.scale_in_cooldown
    scale_out_cooldown = var.memory_scale_out_cooldown != null ? var.memory_scale_out_cooldown : var.scale_out_cooldown

    # Disable scale-in to avoid frequently removing instances (optional)
    disable_scale_in = var.memory_disable_scale_in != null ? var.memory_disable_scale_in : var.disable_scale_in
  }
}