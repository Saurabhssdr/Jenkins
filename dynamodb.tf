resource "aws_dynamodb_table" "csv_data_table" {
  name           = "CSVDataTable"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "ID"
 
  attribute {
    name = "ID"
    type = "S"
  }
}