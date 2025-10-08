# SNS Auto Scaling Spot Instance Alert

Terraform infrastructure for monitoring Auto Scaling Group spot instance failures.

## Project Structure

```
sns-autoscaling-alert/
├── modules/                    # Reusable Terraform modules
│   ├── sns/                   # SNS topic and subscription
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── lambda/                # Lambda function
│   │   ├── lambda.tf          # Lambda resources
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── iam/                   # IAM roles and policies
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/              # Environment-specific configurations
│   └── prod/                 # Production environment
│       ├── main.tf           # Main configuration
│       └── outputs.tf        # Outputs
└── README.md                 # This file
```

## Deployment

1. **Configure Slack webhook** in `environments/prod/main.tf`:
   ```hcl
   slack_webhook_url = "https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
   ```

2. **Package Lambda**:
   ```bash
   zip lambda.zip lambda_function.py
   ```

3. **Deploy**:
   ```bash
   cd environments/prod
   terraform init
   terraform plan
   terraform apply
   ```

## Professional Features

- **Modular Architecture**: Separate modules for each service
- **Environment Isolation**: Clean separation of environments  
- **Resource Tagging**: Consistent tagging strategy
- **Security Best Practices**: SNS encryption, proper IAM
- **Clean Structure**: No scripts, pure Terraform workflow

## Configuration

Edit `environments/prod/main.tf`:

```hcl
locals {
  slack_webhook_url      = ""           # Add your Slack webhook
  autoscaling_group_name = "test-asg"   # Your ASG name
  environment           = "prod"
  project_name          = "autoscaling-alerts"
}
```