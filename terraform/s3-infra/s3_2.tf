resource "aws_s3_bucket" "prod_bucket" {
  bucket = "prod-s3-infra-bucket"

  tags = {

  }
}

resource "aws_s3_bucket_versioning" "prod_bucket_versioning" {
  bucket = aws_s3_bucket.prod_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "prod_bucket_encryption" {
  bucket = aws_s3_bucket.prod_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}





resource "aws_s3_bucket_public_access_block" "prod_bucket_access_block" {
  bucket = aws_s3_bucket.prod_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}
