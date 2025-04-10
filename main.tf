provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "csv_bucket" {
  bucket = "my-5task-buck"  # must be globally unique
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/csvReader"
  retention_in_days = 7
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_s3_read_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_s3_read_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
          "${aws_s3_bucket.csv_bucket.arn}",
          "${aws_s3_bucket.csv_bucket.arn}/*"
        ]
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_function"
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "csv_lambda" {
  function_name = "csvReader"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.9"
  filename      = data.archive_file.lambda_zip.output_path
  depends_on    = [aws_iam_role_policy_attachment.attach_policy]
}
