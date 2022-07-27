import json
import boto3
import logging
import os
from botocore.exceptions import ClientError

import datetime
from dateutil.relativedelta import relativedelta
startCAU = datetime.date.today() - relativedelta(months=3)
endCAU = datetime.date.today()
startFC = datetime.date.today()
endFC = datetime.date.today() + relativedelta(months=1) 

logger = logging.getLogger(__name__)


def send_queue_message(message):
    # Get the service resource
    sqs = boto3.resource('sqs')
    
    # Get the queue
    queue = sqs.get_queue_by_name(QueueName=os.environ['sqs'])
    
    # Create a new message
    response = queue.send_message(MessageBody=json.dumps(message))
    print(response.get('MessageId'))




def lambda_handler(event, context):
    client = boto3.client('ce',region_name=os.environ['region'])
    
    CAUMsg = client.get_cost_and_usage(
        TimePeriod={
            'Start': startCAU.isoformat(),
            'End' : endCAU.isoformat()
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
    
    ForecastMsg = client.get_cost_forecast(
        TimePeriod={
            'Start': startFC.isoformat(),
            'End' : endFC.isoformat()
        },
        Granularity='MONTHLY',
        Metric = "BLENDED_COST",
    )
    # TODO implement
    print("======>",CAUMsg)
    send_queue_message(CAUMsg)
    #send_queue_message(ForecastMsg)
    
    return {
        'statusCode': 200,
        'body': json.dumps(ForecastMsg)
    }