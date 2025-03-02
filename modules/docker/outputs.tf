#modules/docker/outputs

output "image_uri" {
  description = "Full URI of the pushed Docker image"
  value       = "${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.repository_name}:${var.image_tag}"
}