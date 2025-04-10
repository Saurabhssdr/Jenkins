import boto3
import csv

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    bucket = 'my-5task-buck'  # replace during deployment
    key = 'employees.csv'             # replace with your CSV file name

    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        lines = response['Body'].read().decode('utf-8').splitlines()
        reader = csv.reader(lines)
        for row in reader:
            print(row)
    except Exception as e:
        print(f"Error reading CSV: {e}")
