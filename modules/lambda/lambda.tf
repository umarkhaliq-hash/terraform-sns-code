data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "/tmp/lambda.zip"
  source {
    content = <<EOF
import json
import urllib3
import os
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        slack_webhook = os.environ.get('SLACK_WEBHOOK_URL')
        if not slack_webhook:
            logger.error("SLACK_WEBHOOK_URL not configured")
            return {'statusCode': 500}
        
        for record in event['Records']:
            try:
                message = json.loads(record['Sns']['Message'])
            except json.JSONDecodeError as e:
                logger.error(f"Failed to parse SNS message: {str(e)}")
                continue
            
            if 'EC2_INSTANCE_LAUNCH_ERROR' in message.get('Event', ''):
                cause = message.get('Cause', '')
                if 'Spot' in cause and ('capacity' in cause.lower() or 'unavailable' in cause.lower()):
                    
                    slack_message = {
                        "text": "Spot Instance Launch Failed",
                        "blocks": [{
                            "type": "section",
                            "text": {
                                "type": "mrkdwn",
                                "text": f"*Auto Scaling Group:* {message.get('AutoScalingGroupName')}\\n*Cause:* {cause}\\n*Time:* {message.get('Time')}"
                            }
                        }]
                    }
                    
                    try:
                        http = urllib3.PoolManager()
                        response = http.request('POST', slack_webhook,
                                    body=json.dumps(slack_message),
                                    headers={'Content-Type': 'application/json'})
                        if response.status != 200:
                            logger.error(f"Slack webhook failed with status: {response.status}")
                        else:
                            logger.info(f"Alert sent for ASG: {message.get('AutoScalingGroupName')}")
                    except Exception as e:
                        logger.error(f"Failed to send Slack notification: {str(e)}")
        
        return {'statusCode': 200}
    except KeyError as e:
        logger.error(f"Missing required environment variable: {str(e)}")
        return {'statusCode': 500}
    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        return {'statusCode': 500}
EOF
    filename = "lambda_function.py"
  }
}

resource "aws_lambda_function" "this" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = var.function_name
  role         = var.lambda_role_arn
  handler      = "lambda_function.lambda_handler"
  runtime      = "python3.11"
  timeout      = 30
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = var.environment_variables
  }
}

resource "aws_lambda_permission" "sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}