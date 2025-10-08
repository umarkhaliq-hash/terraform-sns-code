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

module "eventbridge" {
  source        = "../../modules/eventbridge"
  rule_name     = "${local.project_name}-spot-failure-${local.environment}"
  sns_topic_arn = module.sns.topic_arn
}

module "sns" {
  source            = "../../modules/sns"
  topic_name        = "${local.project_name}-${local.environment}"
  slack_webhook_url = local.slack_webhook_url
}

