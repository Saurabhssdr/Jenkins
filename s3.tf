provider "aws" {
  region = "ap-southeast-1"
}
resource "aws_s3_bucket" "csv_upload_bucket" {
  bucket = "csv-to-dynamodb-vidya-vc"
}
 