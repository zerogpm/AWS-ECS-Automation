# Create a new IAM policy
resource "aws_iam_policy" "service_discovery_policy" {
  name        = "EcsServiceDiscoveryPolicy"
  description = "Policy to allow ECS tasks to use Service Discovery"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "servicediscovery:RegisterInstance",
          "servicediscovery:DeregisterInstance",
          "servicediscovery:DiscoverInstances",
          "servicediscovery:GetInstancesHealthStatus",
          "route53:CreateHealthCheck",
          "route53:DeleteHealthCheck",
          "route53:GetHealthCheck",
          "route53:UpdateHealthCheck",
          "route53:ChangeResourceRecordSets",
          "route53:GetHealthCheck"
        ]
        Resource = "*"
      }
    ]
  })
}

# SSM policy for ECS Execute Command
resource "aws_iam_policy" "ecs_ssm_policy" {
  name        = "ecs-ssm-execute-command-policy"
  description = "Allow ECS tasks to use SSM for Execute Command"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        Resource = "*"
      }
    ]
  })
}

# Get a reference to the existing role
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

# Attach the policy to the existing role
resource "aws_iam_role_policy_attachment" "service_discovery_policy_attachment" {
  role       = data.aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.service_discovery_policy.arn
}

# Attach the SSM Managed Instance Core policy for comprehensive SSM capabilities
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = "ecsTaskExecutionRole"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}