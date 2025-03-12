# /modules/ecr/task-definition/variables.tf

variable "repository_read_write_access_arns" {
  description = "List of ARNs with read/write access to the repository"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "repository_name" {
  description = "repository name"
  type        = string
}

variable "image_tag" {
  description = "Tag for the Docker image (e.g., latest)"
  type        = string
  default     = "latest"
}