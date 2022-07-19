import json
import boto3
import logging
import sys
from botocore.exceptions import ClientError
import datetime
from dateutil.relativedelta import relativedelta

logger = logging.getLogger(__name__)

sqs = boto3.resource('sqs')
queue = sqs.get_queue_by_name(QueueName='test') - look for queue name

def send_message(queue, message_body):

    try:
        response = queue.send_message(
            MessageBody=message_body,
        )
    except ClientError as error:
        logger.exception("Send message failed: %s", message_body)
        raise error
    else:
        return response

def lambda_handler(event, context):
    client = boto3.client('ce',region_name='eu-west-2')
    start = datetime.date.today() - relativedelta(months=3)
    end = datetime.date.today() 
    print(start)
    CAUMsg = client.get_cost_and_usage(
        TimePeriod={
            'Start': start.isoformat(),
            'End' : end.isoformat()
        },
        Granularity='MONTHLY',
        Metrics = ["BlendedCost"],
        GroupBy = [
        {
            'Type': 'DIMENSION',
            'Key': 'SERVICE'
        },
        {
            'Type': 'TAG',
            'Key': 'Name'
        }
    ]
    )
    # print(response)
    # TODO implement
    
    return {
        'statusCode': 200,
        'body': json.dumps(CAUMsg)
    }