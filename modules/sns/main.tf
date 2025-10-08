resource "aws_sns_topic" "this" {
  name              = var.topic_name
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_subscription" "slack" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "https"
  endpoint  = var.slack_webhook_url
}