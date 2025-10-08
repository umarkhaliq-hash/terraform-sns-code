variable "rule_name" {
  description = "Name of the EventBridge rule"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}