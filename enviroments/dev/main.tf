# environments/dev/main.tf

# Call the VPC module from your modular structure
module "vpc" {
  source = "../../modules/networking/vpc"

  # Pass name_prefix from your local values
  name_prefix = local.name
  vpc_name    = "main"

  # VPC CIDR and networking configuration
  vpc_cidr_block         = var.vpc_cidr_block
  vpc_availability_zones = var.vpc_availability_zones
  vpc_public_subnets     = var.vpc_public_subnets
  vpc_private_subnets    = var.vpc_private_subnets
  vpc_database_subnets   = var.vpc_database_subnets

  # Subnet configuration
  vpc_create_database_subnet_group       = var.vpc_create_database_subnet_group
  vpc_create_database_subnet_route_table = var.vpc_create_database_subnet_route_table

  # NAT Gateway configuration
  vpc_enable_nat_gateway = var.vpc_enable_nat_gateway
  vpc_single_nat_gateway = var.vpc_single_nat_gateway

  # Pass the common tags from your local values
  tags = local.common_tags
}

module "security" {
  source = "../../modules/security"
  vpc_id = module.vpc.vpc_id
  tags   = local.common_tags
  vpc_cidr = var.vpc_cidr_block
}

module "loadbalancer" {
  source = "../../modules/alb"
  
  name   = "app"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_groups = [module.security.loadbalancer_security_group_id]
  health_check_path = "/"  # Health check path for the frontend service
  
  tags = local.common_tags
  
  depends_on = [module.vpc, module.security]
}

module "ecr" {
  source                            = "../../modules/ecr"
  repository_name                   = var.repository_name # This parameter is required according to your variables.tf
  repository_read_write_access_arns = var.repository_read_write_access_arns

  # Optionally add tags
  tags = local.common_tags # Assuming you have common_tags defined in locals
}

# Then build and push the Docker images to the single repository with different tags
module "docker_build" {
  source = "../../modules/docker"
  
  region = var.aws_region
  repository_read_write_access_arns = var.repository_read_write_access_arns
  repository_name = var.repository_name  # Use the same repository name
  
  docker_builds = {
    "frontend" = {
      image_name          = "frontend"
      image_tag           = var.image_tag
      dockerfile_path     = "${path.module}/../../app/client/Dockerfile"
      docker_context_path = "${path.module}/../../app/client"
    },
    "backend" = {
      image_name          = "backend"
      image_tag           = var.image_tag
      dockerfile_path     = "${path.module}/../../app/server/Dockerfile"
      docker_context_path = "${path.module}/../../app/server"
    }
  }
  
  # This explicit dependency ensures ECR repository exists before Docker attempts to push
  depends_on = [module.ecr]
}

# Call the ECS module
module "ecs" {
  source = "../../modules/ecs"

  # ECS cluster configuration
  cluster_name              = var.cluster_name
  enable_container_insights = var.enable_container_insights
  logs_retention_days       = var.logs_retention_days

  # Pass the common tags from your local values
  tags = local.common_tags
}

# Frontend task definition
module "frontend_task_definition" {
  source = "../../modules/ecs/frontend-task-definition"
  
  repository_name = var.repository_name
  image_tag       = var.image_tag
  
  tags = local.common_tags
}

# Backend task definition
module "backend_task_definition" {
  source = "../../modules/ecs/backend-task-definition"
  
  repository_name = var.repository_name
  image_tag       = var.image_tag
  
  tags = local.common_tags
}

# Frontend ECS Service
module "frontend_service" {
  source = "../../modules/ecs/service"
  
  name            = "frontend"
  cluster         = module.ecs.ecs_cluster_arn
  task_definition = module.frontend_task_definition.task_definition_arn
  
  # Container configuration - override the default settings
  container_name  = "frontend"  # Must match name in your task definition
  container_port  = 3000
  
  # Network configuration
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets
  security_groups = [module.security.frontend_security_group_id]

   # Add the ALB target group
  target_group_arn = module.loadbalancer.frontend_target_group_arn
  
  # Service Discovery configuration
  enable_service_discovery   = true

  # Reuse the same namespace as backend (tip-project.local)
  existing_namespace_id    = module.backend_service.namespace_id
  create_namespace = false
  service_discovery_name     = "frontend-service"
  service_discovery_description = "Frontend web application"
  dns_ttl                    = 15
  
  tags = local.common_tags
  
  depends_on = [
    module.ecs,
    module.frontend_task_definition,
    module.loadbalancer
  ]
}

# Backend ECS Service
module "backend_service" {
  source = "../../modules/ecs/service"
  
  name            = "backend"
  cluster         = module.ecs.ecs_cluster_arn
  task_definition = module.backend_task_definition.task_definition_arn
  
  # Container configuration - override the default settings
  container_name  = "backend"  # Must match name in your task definition
  container_port  = 5000
  
  # Network configuration
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets
  security_groups = [module.security.backend_security_group_id]
  
  # Service Discovery configuration
  enable_service_discovery   = true
  create_namespace           = true
  namespace_name             = "tip-project.local"
  namespace_description      = "Backend services"
  service_discovery_name     = "backend-service"
  service_discovery_description = "Namespace for new application"
  dns_ttl                    = 15
  
  tags = local.common_tags
  
  depends_on = [
    module.ecs,
    module.backend_task_definition
  ]
}

# IAM policy for ECS logging
resource "aws_iam_policy" "ecs_logging_policy" {
  name        = "ecs-logging-policy"
  description = "Allow ECS tasks to create and write to CloudWatch log groups"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Attach the policy to the ECS task execution role
resource "aws_iam_role_policy_attachment" "ecs_logging_policy_attachment" {
  role       = "ecsTaskExecutionRole"  # This is the exact name from your task definition
  policy_arn = aws_iam_policy.ecs_logging_policy.arn
}