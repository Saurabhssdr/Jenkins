import boto3
import csv
import io
import uuid
 
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('CSVDataTable')
 
def lambda_handler(event, context):
    s3 = boto3.client('s3')
    bucket = event['detail']['bucket']['name']
    key = event['detail']['object']['key']
 
    response = s3.get_object(Bucket=bucket, Key=key)
    content = response['Body'].read().decode('utf-8')
    csv_reader = csv.DictReader(io.StringIO(content))
 
    for row in csv_reader:
        row['ID'] = str(uuid.uuid4())  # Add unique ID
        table.put_item(Item=row)
 
    return {"status": "success"}
 