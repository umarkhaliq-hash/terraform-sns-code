terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  environment             = "prod"
  project_name           = "autoscaling-alerts"
  slack_webhook_url      = ""
  autoscaling_group_name = "test-asg"
}

module "iam" {
  source    = "../../modules/iam"
  role_name = "${local.project_name}-lambda-role-${local.environment}"
}

module "lambda" {
  source        = "../../modules/lambda"
  function_name = "${local.project_name}-slack-notifier-${local.environment}"
  lambda_role_arn = module.iam.role_arn
  sns_topic_arn = module.sns.topic_arn
  
  environment_variables = {
    SLACK_WEBHOOK_URL = local.slack_webhook_url
  }
}

module "sns" {
  source              = "../../modules/sns"
  topic_name          = "${local.project_name}-${local.environment}"
  lambda_function_arn = module.lambda.function_arn
}

resource "aws_autoscaling_notification" "spot_failures" {
  group_names = [local.autoscaling_group_name]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
  ]

  topic_arn = module.sns.topic_arn
}