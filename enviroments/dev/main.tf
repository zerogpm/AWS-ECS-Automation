# environments/dev/main.tf

# Call the VPC module from your modular structure
# module "vpc" {
#   source = "../../modules/networking/vpc"
  
#   # Pass name_prefix from your local values
#   name_prefix = local.name
#   vpc_name    = "main"
  
#   # VPC CIDR and networking configuration
#   vpc_cidr_block         = var.vpc_cidr_block
#   vpc_availability_zones = var.vpc_availability_zones
#   vpc_public_subnets     = var.vpc_public_subnets
#   vpc_private_subnets    = var.vpc_private_subnets
#   vpc_database_subnets   = var.vpc_database_subnets
  
#   # Subnet configuration
#   vpc_create_database_subnet_group      = var.vpc_create_database_subnet_group
#   vpc_create_database_subnet_route_table = var.vpc_create_database_subnet_route_table
  
#   # NAT Gateway configuration
#   vpc_enable_nat_gateway = var.vpc_enable_nat_gateway
#   vpc_single_nat_gateway = var.vpc_single_nat_gateway
  
#   # Pass the common tags from your local values
#   tags = local.common_tags
# }

# module "ecr" {
#   source = "../../modules/ecr"
#   repository_name = var.repository_name  # This parameter is required according to your variables.tf
#   repository_read_write_access_arns = var.repository_read_write_access_arns
  
#   # Optionally add tags
#   tags = local.common_tags  # Assuming you have common_tags defined in locals
# }

# Call the ECS module
module "ecs" {
  source = "../../modules/ecs"
  
  # ECS cluster configuration
  cluster_name = var.cluster_name
  enable_container_insights = var.enable_container_insights
  logs_retention_days = var.logs_retention_days
  
  # Pass the common tags from your local values
  tags = local.common_tags
}