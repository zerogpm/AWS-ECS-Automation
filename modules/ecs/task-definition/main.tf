# modules/ecs/task-definition/main.tf

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# ECS Task Definition for Frontend
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
          "awslogs-group"         = "/ecs/tip-${var.name}"
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
}