resource "aws_cloudwatch_event_rule" "s3_upload_rule" {
  name        = "S3UploadCSVRule"
  description = "Triggered when new CSV is uploaded to S3"
  event_pattern = jsonencode({
    "source": ["aws.s3"],
    "detail-type": ["Object Created"],
    "detail": {
      "bucket": {
        "name": [aws_s3_bucket.csv_upload_bucket.bucket]
      }
    }
  })
}
 
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.s3_upload_rule.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.csv_to_dynamodb_lambda.arn
}
 
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.csv_to_dynamodb_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.s3_upload_rule.arn
}