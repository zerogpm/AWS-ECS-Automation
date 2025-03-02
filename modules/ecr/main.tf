# modules/ecr/main.tf
module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name                 = var.repository_name
  repository_image_tag_mutability = "MUTABLE"

  repository_read_write_access_arns = var.repository_read_write_access_arns
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Delete untagged images",
        selection = {
          tagStatus   = "untagged",
          countType   = "sinceImagePushed",
          countUnit   = "days",
          countNumber = 1
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = var.tags
}