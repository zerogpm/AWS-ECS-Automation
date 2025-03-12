# modules/docker/variables.tf
variable "region" {
  description = "AWS region"
  type        = string
}

variable "repository_read_write_access_arns" {
  description = "List of ARNs with read/write access to the repository"
  type        = list(string)
}

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "docker_builds" {
  description = "Map of Docker builds to create"
  type = map(object({
    image_name          = string
    image_tag           = string
    dockerfile_path     = string
    docker_context_path = string
  }))
}