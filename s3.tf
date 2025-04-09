resource "aws_s3_bucket" "my_buck" {
  bucket = "terraform-bucket-vc"
  force_destroy = true

  # Explicitly set region
  provider = aws.us_east_1
}
