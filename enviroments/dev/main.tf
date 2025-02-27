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
  vpc_create_database_subnet_group      = var.vpc_create_database_subnet_group
  vpc_create_database_subnet_route_table = var.vpc_create_database_subnet_route_table
  
  # NAT Gateway configuration
  vpc_enable_nat_gateway = var.vpc_enable_nat_gateway
  vpc_single_nat_gateway = var.vpc_single_nat_gateway
  
  # Pass the common tags from your local values
  tags = local.common_tags
}