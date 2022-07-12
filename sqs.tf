data "aws_caller_identity" "current" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
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

resource "aws_sqs_queue_policy" "test" {
  queue_url = aws_sqs_queue.base_queue.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "Queue1_Policy_UUID",
  "Statement": 
  [
    {
      "Sid": "Queue1_AllActions",
      "Effect": "Allow",
      "Principal": 
        { 
          "AWS":
          [ 
            "arn:aws:iam::"${var.destintion_account}":role/cross-account-lambda-sqs-role"
          ] 
        }, 
      "Action": "sqs:*",       
      "Resource": "arn:aws:sqs:us-east-1:"${local.account_id}":LambdaCrossAccountQueue"     
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
  policy      = data.aws_iam_policy_document.consumer_policy.json
}

data "aws_iam_policy_document" "consumer_policy" {
  statement {
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:ChangeMessageVisibilityBatch",
      "sqs:DeleteMessage",
      "sqs:DeleteMessageBatch",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage"
    ]
    resources = [
      aws_sqs_queue.base_queue.arn,
      aws_sqs_queue.deadletter_queue.arn
    ]
  }
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