# S3 Bucket Resource
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "terraform-state-bucket-project-new-973148501077123-tf"

  tags = {
    Name        = "terraform-state-bucket"
    Environment = "Dev"
  }
}

# Enable Versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


# Disable Block Public Policies
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Create Folder
resource "aws_s3_bucket_object" "folder" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = "terraform-tf-state-remote/"
  acl    = "private"
}
