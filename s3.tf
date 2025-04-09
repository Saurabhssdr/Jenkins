provider "aws" {
  region = "ap-south-1"
}
resource "aws_s3_bucket" "my_buck" {
  bucket = "terraform-bucket-vc-vc"
  force_destroy = true
}
