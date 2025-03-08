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
}

module "loadbalancer" {
  source = "../../modules/alb"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_groups = [module.security.loadbalancer_security_group_id]
  depends_on = [module.vpc]
  tags = local.common_tags
}

module "ecr" {
  source                            = "../../modules/ecr"
  repository_name                   = var.repository_name # This parameter is required according to your variables.tf
  repository_read_write_access_arns = var.repository_read_write_access_arns

  # Optionally add tags
  tags = local.common_tags # Assuming you have common_tags defined in locals
}

#Add Docker build and push module
module "docker_build" {
  source = "../../modules/docker"

  region                            = var.aws_region
  repository_read_write_access_arns = var.repository_read_write_access_arns
  repository_name                   = var.repository_name
  image_name                        = var.image_name
  image_tag                         = var.image_tag
  dockerfile_path                   = "${path.module}/../../react-app/Dockerfile.dev"
  docker_context_path               = "${path.module}/../../react-app"

  depends_on = [module.ecr] # Ensure ECR repo exists first
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

module "ecs_task_definition" {
  source = "../../modules/ecs/task-definition"
  repository_read_write_access_arns = var.repository_read_write_access_arns
  repository_name = var.repository_name
  tags = local.common_tags
}

module "ecs_service" {
  source = "../../modules/ecs/service"
  vpc_id = module.vpc.vpc_id
  cluster = module.ecs.ecs_cluster_arn
  alb_arn = module.loadbalancer.alb_arn
  task_definition = module.ecs_task_definition.task_definition_arn
  ecs_task_security_group_id = module.security.ecs_task_security_group_id
  subnets = module.vpc.public_subnets
  tags = local.common_tags
  depends_on = [module.ecs, module.ecs_task_definition]
}