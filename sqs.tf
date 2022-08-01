data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

##
## The primary and dead-letter queues
##

resource "aws_sqs_queue" "base_queue" {
  name                       = "${var.prefix}-report-delivery-queue"
  message_retention_seconds  = 86400
  visibility_timeout_seconds = 60
  redrive_policy = jsonencode({
    "deadLetterTargetArn" = aws_sqs_queue.deadletter_queue.arn,
    "maxReceiveCount"     = 3
  })
}

resource "aws_sqs_queue" "deadletter_queue" {
  name                       = "${var.prefix}-report-delivery-DLQ"
  message_retention_seconds  = 86400
  visibility_timeout_seconds = 60
}

resource "aws_sqs_queue_policy" "sqspolicy" {
  queue_url = aws_sqs_queue.base_queue.id

  policy = <<POLICY

{
  "Version": "2012-10-17",
  "Id": "Queue_Policy_access",
  "Statement": [
    {
      "Sid": "Queue_Actions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.cross_account_role}"
      },
      "Action": "sqs:*",
      "Resource": "${aws_sqs_queue.base_queue.arn}"
    },
    {
      "Sid": "Queue_Actions2",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::798680644831:role/cross-account-lambda-sqs-role"
      },
      "Action": "sqs:*",
      "Resource": "arn:aws:sqs:eu-west-2:484165963982:dev-report-delivery-queue"
    }
  ]
}
POLICY
}




