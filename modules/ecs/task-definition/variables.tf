#modules/ecs/task-definition/variables.tf

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag" {
  description = "Tag for the Docker image"
  type        = string
  default     = "latest"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Tag for the Docker image"
  type        = string
  default     = "frontend"
}

variable "port" {
  description = "port number for task definition"
  type        = number
  default     = 3000
}

variable "memory" {
  description = "Amount of memory for the task (in MiB)"
  type        = string
  default     = "1024"
}

variable "cpu" {
  description = "Amount of memory for the task (in MiB)"
  type        = string
  default     = "512"
}