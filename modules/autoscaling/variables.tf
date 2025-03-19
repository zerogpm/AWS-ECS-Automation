variable "name" {
  description = "Name prefix for the autoscaling resources"
  type        = string
}

# ALB request-based autoscaling variables
variable "enable_alb_request_scaling" {
  description = "Whether to enable ALB request count-based autoscaling"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "execution_role_name" {
  description = "Name of the ECS task execution IAM role"
  type        = string
  default     = "ecsTaskExecutionRole"
}

variable "service_name" {
  description = "Name of the ECS service to scale"
  type        = string
}

variable "min_capacity" {
  description = "Minimum number of tasks"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of tasks"
  type        = number
  default     = 5
}

variable "target_request_count" {
  description = "Target number of requests per target (task) that triggers scaling"
  type        = number
  default     = 1000
}

variable "scale_in_cooldown" {
  description = "Cooldown period in seconds before allowing another scale in activity"
  type        = number
  default     = 300
}

variable "scale_out_cooldown" {
  description = "Cooldown period in seconds before allowing another scale out activity"
  type        = number
  default     = 60
}

variable "disable_scale_in" {
  description = "Whether scale in by the target tracking policy is disabled"
  type        = bool
  default     = false
}

variable "alb_arn_suffix" {
  description = "ARN suffix of the ALB (the part after loadbalancer/)"
  type        = string
  default     = ""
}

variable "target_group_arn_suffix" {
  description = "ARN suffix of the target group (the part after targetgroup/)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
  default     = {}
}

# CPU-based autoscaling variables
variable "enable_cpu_scaling" {
  description = "Whether to enable CPU-based autoscaling"
  type        = bool
  default     = false
}

variable "target_cpu_utilization" {
  description = "Target CPU utilization percentage that triggers scaling"
  type        = number
  default     = 70
}

variable "cpu_scale_in_cooldown" {
  description = "Cooldown period in seconds before allowing another CPU-based scale in activity"
  type        = number
  default     = null
}

variable "cpu_scale_out_cooldown" {
  description = "Cooldown period in seconds before allowing another CPU-based scale out activity"
  type        = number
  default     = null
}

variable "cpu_disable_scale_in" {
  description = "Whether CPU-based scale in is disabled"
  type        = bool
  default     = null
}

# Memory-based autoscaling variables
variable "enable_memory_scaling" {
  description = "Whether to enable memory-based autoscaling"
  type        = bool
  default     = false
}

variable "target_memory_utilization" {
  description = "Target memory utilization percentage that triggers scaling"
  type        = number
  default     = 70
}

variable "memory_scale_in_cooldown" {
  description = "Cooldown period in seconds before allowing another memory-based scale in activity"
  type        = number
  default     = null
}

variable "memory_scale_out_cooldown" {
  description = "Cooldown period in seconds before allowing another memory-based scale out activity"
  type        = number
  default     = null
}

variable "memory_disable_scale_in" {
  description = "Whether memory-based scale in is disabled"
  type        = bool
  default     = null
}