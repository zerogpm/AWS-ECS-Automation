# Create a new IAM policy for Service Connect
resource "aws_iam_policy" "service_connect_policy" {
  name        = "EcsServiceConnectPolicy"
  description = "Policy to allow ECS tasks to use Service Connect"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "servicediscovery:DiscoverInstances",
          "servicediscovery:ListNamespaces",
          "servicediscovery:ListServices"
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

# IAM policy for ECS logging
resource "aws_iam_policy" "ecs_logging_policy" {
  name        = "ecs-logging-policy"
  description = "Allow ECS tasks to create and write to CloudWatch log groups"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Get a reference to the existing role
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

# Attach the Service Connect policy to the existing role
resource "aws_iam_role_policy_attachment" "service_connect_policy_attachment" {
  role       = data.aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.service_connect_policy.arn
}

# Attach the SSM policy for Execute Command
resource "aws_iam_role_policy_attachment" "ecs_ssm_policy_attachment" {
  role       = data.aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_ssm_policy.arn
}

# Attach the SSM Managed Instance Core policy for comprehensive SSM capabilities
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = data.aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach the logging policy to the ECS task execution role
resource "aws_iam_role_policy_attachment" "ecs_logging_policy_attachment" {
  role       = data.aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_logging_policy.arn
}