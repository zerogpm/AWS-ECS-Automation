# # ECS Service
# resource "aws_ecs_service" "service" {
#   name            = "svc"
#   cluster         = aws_ecs_cluster.cluster.id
#   task_definition = "arn:aws:ecs:us-east-1:541356534908:task-definition/tip:2"
#   desired_count   = 1
#   launch_type     = "FARGATE"
#   platform_version = "1.4.0"
#   platform_family = "Linux"
#   scheduling_strategy = "REPLICA"
#   health_check_grace_period_seconds = 0
#   enable_ecs_managed_tags = true
#   propagate_tags = "NONE"
#   enable_execute_command = false
#   availability_zone_rebalancing = "ENABLED"

#   capacity_provider_strategy {
#     capacity_provider = "FARGATE"
#     weight            = 1
#     base              = 0
#   }

#   deployment_controller {
#     type = "ECS"
#   }

#   deployment_circuit_breaker {
#     enable   = true
#     rollback = true
#   }

#   # Load balancer configuration
#   load_balancer {
#     target_group_arn = aws_lb_target_group.ecs_target_group.arn
#     container_name   = "app"
#     container_port   = 3000
#   }

#   network_configuration {
#     subnets = [
#       "subnet-0c9121ae235e1523b",
#       "subnet-066d24a6cfa21f58b"
#     ]
#     security_groups = ["sg-019c623214ddff212"]
#     assign_public_ip = true
#   }
# }

# # Application Load Balancer
# resource "aws_lb" "ecs_alb" {
#   name               = "ecs-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = ["sg-019c623214ddff212"] # Using the same security group as the ECS service
#   subnets            = [
#     "subnet-0c9121ae235e1523b",
#     "subnet-066d24a6cfa21f58b"
#   ]

#   enable_deletion_protection = false
# }

# # ALB Listener
# resource "aws_lb_listener" "ecs_alb_listener" {
#   load_balancer_arn = aws_lb.ecs_alb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.ecs_target_group.arn
#   }
# }

# # IAM Role for ECS Service
# data "aws_iam_role" "ecs_service_role" {
#   name = "AWSServiceRoleForECS"
# }