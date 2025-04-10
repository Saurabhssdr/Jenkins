import boto3
import csv
 
def lambda_handler(event, context):
    s3 = boto3.client('s3')
   
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
 
    response = s3.get_object(Bucket=bucket, Key=key)
    lines = response['Body'].read().decode('utf-8').splitlines()
    csv_reader = csv.reader(lines)
   
    for row in csv_reader:
        print(row)
 
    return {
        'statusCode': 200,
        'body': 'CSV data printed successfully'
    }