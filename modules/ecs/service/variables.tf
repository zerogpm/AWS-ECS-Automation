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
  default     = "app"
}

variable "container_port" {
  description = "Port on which the container is listening"
  type        = number
  default     = 3000
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

# Service Connect variables
variable "enable_service_connect" {
  description = "Whether to enable Service Connect for the service"
  type        = bool
  default     = false
}

variable "service_connect_namespace" {
  description = "ARN of the Service Connect namespace"
  type        = string
  default     = ""
}

variable "service_connect_as_client_only" {
  description = "If true, the service will only act as a client in Service Connect (not discoverable)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}