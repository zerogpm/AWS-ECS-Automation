# modules/ecs/task-definition/main.tf

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# CloudWatch Log Group with 1-day retention
resource "aws_cloudwatch_log_group" "tip_log_group" {
  name              = "/ecs/tip-${var.name}"
  retention_in_days = 1

  # This helps handle the case where the resource already exists
  lifecycle {
    # Create new resource before destroying the old one
    create_before_destroy = true
  }

  tags = var.tags
}

# ECS Task Definition
resource "aws_ecs_task_definition" "tip_task_definition" {
  family                   = "tip-${var.name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = var.name
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/${var.repository_name}:${var.name}-${var.image_tag}"
      cpu       = 512
      essential = true
      portMappings = [
        {
          name          = "${var.name}-tcp"
          containerPort = var.port
          hostPort      = var.port
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.tip_log_group.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
          "mode"                  = "non-blocking"
          "max-buffer-size"       = "25m"
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = var.tags

  # Add this dependency to ensure the log group is created before the task definition
  depends_on = [aws_cloudwatch_log_group.tip_log_group]
}