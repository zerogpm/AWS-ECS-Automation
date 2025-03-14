variable "name" {
  description = "Name of the ECS service"
  type        = string
}

variable "cluster" {
  description = "ARN of the ECS cluster"
  type        = string
}

variable "task_definition" {
  description = "ARN of the ECS task definition"
  type        = string
}

variable "container_name" {
  description = "Name of the container in the task definition"
  type        = string
  default     = "app"  # Default value matching your original service
}

variable "container_port" {
  description = "Port on which the container is listening"
  type        = number
  default     = 3000  # Default value matching your original service
}

variable "desired_count" {
  description = "Number of instances of the task to place and keep running"
  type        = number
  default     = 1
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs to place the ECS tasks in"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs to assign to the ECS service"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the target group for the load balancer"
  type        = string
  default     = ""
}

# Service Discovery variables
variable "enable_service_discovery" {
  description = "Whether to enable service discovery for the service"
  type        = bool
  default     = false
}

variable "create_namespace" {
  description = "Whether to create a new namespace for service discovery"
  type        = bool
  default     = false
}

variable "namespace_name" {
  description = "Name of the Cloud Map namespace to create or use"
  type        = string
  default     = ""
}

variable "namespace_description" {
  description = "Description for the Cloud Map namespace"
  type        = string
  default     = ""
}

variable "existing_namespace_id" {
  description = "ID of an existing Cloud Map namespace to use (if not creating a new one)"
  type        = string
  default     = ""
}


variable "service_discovery_name" {
  description = "Name for the service discovery service"
  type        = string
  default     = ""
}

variable "service_discovery_description" {
  description = "Description for the service discovery service"
  type        = string
  default     = ""
}

variable "dns_ttl" {
  description = "TTL for DNS records"
  type        = number
  default     = 15
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}