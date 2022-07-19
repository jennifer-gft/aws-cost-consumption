####SQS 
output "base_queue_url" {
  value = aws_sqs_queue.base_queue.id
}


output "deadletter_queue_url" {
  value = aws_sqs_queue.deadletter_queue.id
}
