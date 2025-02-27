variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "my-serverless-ecs-cluster"
}

variable "enable_container_insights" {
  description = "Enable CloudWatch Container Insights for the cluster"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "logs_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}