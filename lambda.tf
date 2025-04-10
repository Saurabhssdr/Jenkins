 
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_dynamodb"
 
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}
 
resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_s3_dynamodb_policy"
 
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = ["s3:GetObject"],
        Resource = "${aws_s3_bucket.csv_upload_bucket.arn}/*"
      },
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ],
        Resource = aws_dynamodb_table.csv_data_table.arn
      }
    ]
  })
}
 
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
 
resource "aws_lambda_function" "csv_to_dynamodb_lambda" {
  function_name = "CSVToDynamoDBLambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
 
 source_code_hash = filebase64sha256("${path.module}/lambda/lambda_function_dynamodb.zip")
 filename         = "${path.module}/lambda/lambda_function_dynamodb.zip"
 
}
 
 