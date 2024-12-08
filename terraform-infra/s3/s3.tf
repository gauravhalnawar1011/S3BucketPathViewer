resource "aws_s3_bucket" "s3_bucket" {
  bucket = "terraform-accessible-s3-bucket-973148501077"
  acl    = "private"

  tags = {
    Name        = "S3 Bucket for EC2 Access"
    Environment = "Dev"
  }
}

# Create a Folder in the S3 Bucket
resource "aws_s3_bucket_object" "folder" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = "dir1/" # Folder in S3 if want to create the folder
  acl    = "private"
}

resource "aws_s3_bucket_object" "folder" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = "dir/" # Folder in S3 if want to create the folder
  acl    = "private"
}

