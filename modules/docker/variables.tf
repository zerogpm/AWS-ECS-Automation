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

variable "image_name" {
  description = "Name of the Docker image"
  type        = string
}

variable "image_tag" {
  description = "Tag for the Docker image"
  type        = string
  default     = "latest"
}

variable "dockerfile_path" {
  description = "Path to the Dockerfile"
  type        = string
}

variable "docker_context_path" {
  description = "Path to the Docker build context"
  type        = string
}