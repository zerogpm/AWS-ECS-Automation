# AWS ECS Infrastructure with Terraform

This repository contains Terraform code to deploy a serverless ECS infrastructure on AWS, including VPC, ECR repositories, and ECS clusters with Fargate and Fargate Spot capacity providers.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or newer)
- AWS CLI configured with appropriate credentials
- An AWS account with necessary permissions

## Installation

### Install Terraform

#### macOS (using Homebrew)

```shell
brew install terraform
```

#### Linux

```shell
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

#### Windows (using Chocolatey)

```shell
choco install terraform
```

### Verify Installation

```shell
terraform version
```

## Project Structure

```
.
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   └── prod/
│       └── ...
├── modules/
│   ├── ecs/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ecr/
│   │   └── ...
│   └── networking/
│       └── vpc/
│           └── ...
└── README.md
```

## Usage

### Initialize the Project

Navigate to the environment directory you want to deploy (e.g., `environments/dev`):

```shell
cd environments/dev
terraform init
```

### Plan the Deployment

Review the resources that will be created:

```shell
terraform plan
```

### Apply the Configuration

Deploy the infrastructure:

```shell
terraform apply
```

When prompted, type `yes` to confirm.

### Destroy Resources

To tear down the infrastructure:

```shell
terraform destroy
```

## Module Configuration

### ECS Module

The ECS module creates an ECS cluster with Fargate and Fargate Spot capacity providers.

#### Inputs

| Name                      | Description                                     | Type          | Default                       | Required |
| ------------------------- | ----------------------------------------------- | ------------- | ----------------------------- | :------: |
| cluster_name              | Name of the ECS cluster                         | `string`      | `"my-serverless-ecs-cluster"` |    no    |
| enable_container_insights | Whether to enable CloudWatch Container Insights | `bool`        | `true`                        |    no    |
| logs_retention_days       | Number of days to retain ECS logs in CloudWatch | `number`      | `30`                          |    no    |
| tags                      | A map of tags to add to all resources           | `map(string)` | `{}`                          |    no    |

#### Example Usage

```terraform
module "ecs" {
  source = "../../modules/ecs"

  cluster_name = "my-app-cluster"
  enable_container_insights = true
  logs_retention_days = 14

  tags = {
    Environment = "dev"
    Project     = "my-app"
  }
}
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Format your Terraform code (`terraform fmt -recursive`)
4. Commit your changes (`git commit -m 'Add some amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
