# Create ECS Cluster
# modules/ecs/main.tf

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  tags = var.tags
}

# Add Fargate and Fargate Spot capacity providers to the cluster
resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}

# CloudWatch log group for ECS logs
resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.cluster_name}"
  retention_in_days = var.logs_retention_days

  tags = var.tags
}