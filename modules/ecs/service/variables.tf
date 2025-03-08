# modules/ecs/service/variables.tf
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "task_definition" {
  description = "task definition arn"
  type        = string
}

variable "cluster" {
  description = "ecs cluster arn"
  type        = string
}

variable "subnets" {
  description = "service subnet"
  type        = list(string)
  default     = []
}

variable "ecs_task_security_group_id" {
  description = "service sg id"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the Application Load Balancer"
  type        = string
}
