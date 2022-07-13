data "aws_caller_identity" "current" {}

##
## A module to create an SQS queue, along with its dead-letter queue and access policies
##

#provider "aws" {}

data "aws_region" "current" {}

##
## The primary and dead-letter queues
##

resource "aws_sqs_queue" "base_queue" {
  name                        = var.queue_name
  message_retention_seconds   = var.retention_period
  visibility_timeout_seconds  = var.visibility_timeout
  redrive_policy              = jsonencode({
                                    "deadLetterTargetArn" = aws_sqs_queue.deadletter_queue.arn,
                                    "maxReceiveCount" = var.receive_count
                                })
}

resource "aws_sqs_queue" "deadletter_queue" {
  name                        = "${var.queue_name}-DLQ"
  message_retention_seconds   = var.retention_period
  visibility_timeout_seconds  = var.visibility_timeout
}

resource "aws_iam_policy" "sqspolicy" {
  queue_url = aws_sqs_queue.base_queue.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "Queue_Policy_UUID",
  "Statement": 
  [
    {
      "Sid": "Queue1_AllActions",
      "Effect": "Allow",
      "Principal": 
        { 
          "AWS":
          [ 
            "arn:aws:iam:${data.aws_caller_identity.current.account_id}:role/cross-account-lambda-sqs-role"
          ] 
        }, 
      "Action": "sqs:*",       
      "Resource": ${aws_sqs_queue.base_queue.arn}
    }   
  ]
} 
POLICY
}

##
## Managed policies that allow access to the queue
##

resource "aws_iam_policy" "consumer_policy" {
  name        = "SQS-${var.queue_name}-${data.aws_region.current.name}-consumer_policy"
  description = "Attach this policy to consumers of ${var.queue_name} SQS queue"
  policy      = aws_iam_policy.sqspolicy.arn
}



resource "aws_iam_policy" "producer_policy" {
  name        = "SQS-${var.queue_name}-${data.aws_region.current.name}-producer"
  description = "Attach this policy to producers for ${var.queue_name} SQS queue"
  policy      = data.aws_iam_policy_document.producer_policy.json
}

data "aws_iam_policy_document" "producer_policy" {
  statement {
    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:SendMessage",
      "sqs:SendMessageBatch",
      "lambda.*"
    ]
    resources = [
      aws_sqs_queue.base_queue.arn
    ]
  }
}