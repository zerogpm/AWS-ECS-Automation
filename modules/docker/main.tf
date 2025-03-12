
# modules/docker/main.tf
locals {
  # Extract account ID from the first ARN in the list
  # Format of ARN: arn:aws:iam::ACCOUNT_ID:user/username
  account_id = length(var.repository_read_write_access_arns) > 0 ? split(":", var.repository_read_write_access_arns[0])[4] : ""
}

resource "null_resource" "docker_build_push" {
  for_each = var.docker_builds
  
  triggers = {
    # Always force a rebuild for testing
    always_run = "${timestamp()}"
    # Store these values for destroy time usage
    image_name      = each.value.image_name
    image_tag       = each.value.image_tag
    repository_name = var.repository_name
    account_id      = local.account_id
    region          = var.region
  }

  # Break into individual steps for better debugging
  provisioner "local-exec" {
    command = "echo 'Logging into ECR...'"
  }

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  }

  provisioner "local-exec" {
    command = "echo 'Building Docker image for ${each.key}...'"
  }

  provisioner "local-exec" {
    command = "docker build -t ${each.value.image_name}:${each.value.image_tag} -f ${each.value.dockerfile_path} ${each.value.docker_context_path}"
  }

  provisioner "local-exec" {
    command = "echo 'Tagging Docker image for ${each.key}...'"
  }

  # Here we tag with component-specific image tag, not just the version
  provisioner "local-exec" {
    command = "docker tag ${each.value.image_name}:${each.value.image_tag} ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.repository_name}:${each.key}-${each.value.image_tag}"
  }

  provisioner "local-exec" {
    command = "echo 'Pushing Docker image for ${each.key}...'"
  }

  provisioner "local-exec" {
    command = "docker push ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.repository_name}:${each.key}-${each.value.image_tag}"
  }

  # Add the cleanup directly to this resource instead of a separate resource
  provisioner "local-exec" {
    when    = destroy
    command = "docker rmi ${self.triggers.image_name}:${self.triggers.image_tag} ${self.triggers.account_id}.dkr.ecr.${self.triggers.region}.amazonaws.com/${self.triggers.repository_name}:${each.key}-${self.triggers.image_tag} || true"
  }
}