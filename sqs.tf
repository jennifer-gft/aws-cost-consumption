data "aws_caller_identity" "current" {}
resource "aws_sqs_queue_policy" "test" {
  queue_url = aws_sqs_queue.q.id


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
      "Resource": "arn:aws:sqs:us-east-1:"${data.aws_caller_identity.current}":LambdaCrossAccountQueue"     
    }   
  ]
} 
POLICY
}