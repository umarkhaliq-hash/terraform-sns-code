resource "aws_cloudwatch_event_rule" "autoscaling_spot_failure" {
  name        = var.rule_name
  description = "Capture Auto Scaling spot instance failures"

  event_pattern = jsonencode({
    source      = ["aws.autoscaling"]
    detail-type = ["EC2 Instance Launch Unsuccessful"]
    detail = {
      cause = [{
        prefix = "Spot"
      }]
    }
  })
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.autoscaling_spot_failure.name
  target_id = "SendToSNS"
  arn       = var.sns_topic_arn
}