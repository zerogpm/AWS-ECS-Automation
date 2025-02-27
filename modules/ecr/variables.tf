# modules/ecr/variables.tf
variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "repository_read_write_access_arns" {
  description = "ARNs of IAM roles/users that have read/write access to the ECR repository"
  type        = list(string)
  default     = []
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}