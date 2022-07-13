import boto3
import json

def lambda_handler(event, context):
    current_data = event
     
    return {
        "statusCode": 200,
        "body": json.dumps({
            "result": current_data
        }),
    }