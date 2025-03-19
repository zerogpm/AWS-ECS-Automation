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
  source   = "../../modules/security"
  vpc_id   = module.vpc.vpc_id
  tags     = local.common_tags
  vpc_cidr = var.vpc_cidr_block
}

module "loadbalancer" {
  source = "../../modules/alb"

  name              = "app"
  vpc_id            = module.vpc.vpc_id
  subnets           = module.vpc.public_subnets
  security_groups   = [module.security.loadbalancer_security_group_id]
  health_check_path = "/" # Health check path for the frontend service

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

  region                            = var.aws_region
  repository_read_write_access_arns = var.repository_read_write_access_arns
  repository_name                   = var.repository_name # Use the same repository name

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
  source          = "../../modules/ecs/task-definition"
  repository_name = var.repository_name
  image_tag       = var.image_tag
  name            = "frontend"
  port            = 3000
  cpu             = "512"
  memory          = "1024"
  tags            = local.common_tags
}

# Backend task definition
module "backend_task_definition" {
  source          = "../../modules/ecs/task-definition"
  repository_name = var.repository_name
  image_tag       = var.image_tag
  name            = "backend"
  port            = 5000
  cpu             = "512"
  memory          = "2048"
  tags            = local.common_tags
}

# Create a Service Connect namespace separately
resource "aws_service_discovery_http_namespace" "service_connect" {
  name        = "tip-project"
  description = "Service Connect namespace for all services"

  tags = local.common_tags
}

# Frontend ECS Service
module "frontend_service" {
  source = "../../modules/ecs/service"

  name            = "frontend"
  cluster         = module.ecs.ecs_cluster_arn
  task_definition = module.frontend_task_definition.task_definition_arn

  # Set the desired count to min_capacity - will be managed by autoscaling
  desired_count = 2

  # Container configuration - override the default settings
  container_name = "frontend" # Must match name in your task definition
  container_port = 3000

  # Network configuration
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets
  security_groups = [module.security.frontend_security_group_id]

  # Add the ALB target group
  target_group_arn = module.loadbalancer.frontend_target_group_arn

  # Service Connect configuration
  enable_service_connect    = true
  service_connect_namespace = aws_service_discovery_http_namespace.service_connect.arn

  tags = local.common_tags

  depends_on = [
    module.ecs,
    module.frontend_task_definition,
    module.loadbalancer,
    module.backend_service
  ]
}

# Frontend Autoscaling using ALB request count scaling
module "frontend_autoscaling" {
  source = "../../modules/autoscaling"

  name                = "frontend"
  cluster_name        = module.ecs.ecs_cluster_name
  service_name        = module.frontend_service.service_name
  execution_role_name = "ecsTaskExecutionRole" # Using your existing IAM role

  # Scaling configuration
  min_capacity = 2
  max_capacity = 10

  # ALB request-based scaling (suitable for frontend services)
  enable_alb_request_scaling = true
  target_request_count       = 500 # Scale out when 500 requests per task is reached

  # Disable CPU-based scaling for frontend
  enable_cpu_scaling = false

  # Disable memory-based scaling for frontend
  enable_memory_scaling = false

  # Cooldown periods to prevent thrashing
  scale_in_cooldown  = 300 # 5 minutes cooldown before scaling in
  scale_out_cooldown = 60  # 1 minute cooldown before scaling out

  # ALB resource identifiers needed for the scaling metric
  alb_arn_suffix          = module.loadbalancer.lb_arn_suffix
  target_group_arn_suffix = module.loadbalancer.frontend_target_group_arn_suffix

  tags = local.common_tags

  depends_on = [
    module.frontend_service
  ]
}

# Backend ECS Service
module "backend_service" {
  source = "../../modules/ecs/service"

  name            = "backend"
  cluster         = module.ecs.ecs_cluster_arn
  task_definition = module.backend_task_definition.task_definition_arn

  # Set the desired count to min_capacity - will be managed by autoscaling
  desired_count = 2

  # Container configuration - override the default settings
  container_name = "backend" # Must match name in your task definition
  container_port = 5000

  # Network configuration
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets
  security_groups = [module.security.backend_security_group_id]

  # Service Connect configuration
  enable_service_connect    = true
  service_connect_namespace = aws_service_discovery_http_namespace.service_connect.arn

  tags = local.common_tags

  depends_on = [
    module.ecs,
    module.backend_task_definition
  ]
}

# Backend Autoscaling with CPU and memory-based scaling
module "backend_autoscaling" {
  source = "../../modules/autoscaling"

  name                = "backend"
  cluster_name        = module.ecs.ecs_cluster_name
  service_name        = module.backend_service.service_name
  execution_role_name = "ecsTaskExecutionRole" # Using your existing IAM role

  # Scaling configuration
  min_capacity = 2
  max_capacity = 8

  # Disable ALB request-based scaling for backend
  enable_alb_request_scaling = false

  # Enable CPU-based scaling for backend
  enable_cpu_scaling     = true
  target_cpu_utilization = 65 # Scale when CPU utilization reaches 65%

  # Since backend might have longer processing times, use longer cooldowns
  scale_in_cooldown  = 600 # 10 minutes cooldown before scaling in
  scale_out_cooldown = 120 # 2 minutes cooldown before scaling out

  # Enable memory-based scaling as well (as a secondary scaling mechanism)
  enable_memory_scaling     = true
  target_memory_utilization = 75 # Scale when memory utilization reaches 75%

  tags = local.common_tags

  depends_on = [
    module.backend_service
  ]
}