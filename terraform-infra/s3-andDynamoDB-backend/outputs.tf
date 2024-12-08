# Output bucket name
output "s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket.bucket
}

# Output DynamoDB table name
output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}
