resource "aws_s3_bucket" "prod_bucket" {
  bucket = "prod-s3-infra-bucket"

  tags = {
    Name        = "prod"
    Environment = "prod-env"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "prod_bucket_versioing" {
  bucket = aws_s3_bucket.prod_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "prod_bucket_public_access" {
  bucket = aws_s3_bucket.prod_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}