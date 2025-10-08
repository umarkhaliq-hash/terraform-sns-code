# EventBridge Auto Scaling Spot Instance Alert

Terraform infrastructure for monitoring Auto Scaling Group spot instance failures using EventBridge.

## Project Structure

```
sns-autoscaling-alert/
├── config.tf                  # Version management
├── modules/                   # Reusable Terraform modules
│   ├── eventbridge/          # EventBridge rules and targets
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── sns/                  # SNS topic and Slack subscription
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/             # Environment-specific configurations
│   └── prod/                # Production environment
│       ├── main.tf          # Main configuration
│       ├── backend.tf       # S3 state storage
│       └── outputs.tf       # Outputs
└── README.md                # This file
```

## Configuration

**Add your Slack webhook URL** in `environments/prod/main.tf`:

```hcl
locals {
  slack_webhook_url = "https://hooks.slack.com/services/YOUR/WEBHOOK/URL"  # ← PUT YOUR WEBHOOK HERE
  environment       = "prod"
  project_name      = "autoscaling-alerts"
}
```

## Deployment

```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

## Architecture

**Flow:** Auto Scaling Group → EventBridge → SNS → Slack

- **EventBridge** automatically captures spot instance failures
- **SNS** forwards alerts directly to Slack
- **No Lambda** required - cleaner serverless architecture

## Features

- **EventBridge Integration**: Native AWS event capture
- **Direct Slack Alerts**: No intermediate processing
- **Modular Design**: Reusable Terraform modules
- **S3 State Backend**: Built-in locking
- **Version Management**: Controlled provider versions