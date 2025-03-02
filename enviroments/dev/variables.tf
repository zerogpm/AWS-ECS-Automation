# Business Division and Environment Variables
# environment/dev/variables.tf
variable "business_division" {
  description = "Business Division in the organization"
  type        = string
  default     = "SRD" # Default value for development environment
}

variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "DEV" # This is the dev environment
}

# AWS Region
variable "aws_region" {
  description = "Region in which AWS resources to be created"
  type        = string
  default     = "us-east-1"
}

# VPC Variables
variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_availability_zones" {
  description = "VPC Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_database_subnets" {
  description = "VPC Database Subnets"
  type        = list(string)
  default     = ["10.0.151.0/24", "10.0.152.0/24"]
}

variable "vpc_create_database_subnet_group" {
  description = "VPC Create Database Subnet Group"
  type        = bool
  default     = true
}

variable "vpc_create_database_subnet_route_table" {
  description = "VPC Create Database Subnet Route Table"
  type        = bool
  default     = true
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateways for Private Subnets Outbound Communication"
  type        = bool
  default     = true
}

variable "vpc_single_nat_gateway" {
  description = "Enable only single NAT Gateway in one Availability Zone to save costs"
  type        = bool
  default     = true
}

variable "repository_read_write_access_arns" {
  description = "ARNs of IAM roles/users that have read/write access to the ECR repository"
  type        = list(string)
  default     = []
  sensitive   = true
}

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "enable_container_insights" {
  description = "Whether to enable CloudWatch Container Insights for the ECS cluster"
  type        = bool
  default     = true
}

variable "logs_retention_days" {
  description = "Number of days to retain ECS logs in CloudWatch"
  type        = number
  default     = 30
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "my-serverless-ecs-cluster"
}

variable "image_name" {
  description = "Name of the Docker image"
  type        = string
}

variable "image_tag" {
  description = "Tag for the Docker image"
  type        = string
  default     = "latest"
}