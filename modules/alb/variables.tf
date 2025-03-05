variable "name" {
  description = "Application Load Balancer Name"
  type        = string
  default     = "SRD" # Default value for development environment
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The ID of the VPC where security resources will be created"
  type        = string
}

variable "security_groups" {
  description = "Application Load Balancer security groups"
  type        = list(string)  # Changed from string to list(string)
}

variable "subnets" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}