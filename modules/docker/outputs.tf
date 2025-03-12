# modules/docker/outputs.tf
output "image_uris" {
  description = "Map of built image URIs"
  value = {
    for name, build in var.docker_builds :
    name => "${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.repository_name}:${name}-${build.image_tag}"
  }
}