resource "aws_lambda_function" "test_lambda" {

  filename      = var.zipName
  function_name = var.LambdaName
  role          = var.LambdaIAM
  handler       = "index.test"

  runtime = "python3.7"

}

resource "aws_cloudwatch_event_rule" "LambdaTrigger" {
  name        = var.EventRuleName
  description = "Cloudwatch Cron Trigger for Lambda Function"
  schedule_expression = var.Schedule

  event_pattern = <<EOF
{
  "detail-type": [
    "AWS Console Lambda Scheduled Run"
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "CWET" {
  rule      = aws_cloudwatch_event_rule.LambdaTrigger.name
  arn       = aws_lambda_function.test_lambda.arn
}
