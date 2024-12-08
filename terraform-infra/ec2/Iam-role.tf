# IAM Role for EC2 instance
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for S3 access
resource "aws_iam_policy" "s3_read_policy" {
  name        = "s3-read-access-policy"
  description = "Allow EC2 instance to access S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::terraform-accessible-s3-bucket-973148501077",  # Bucket ARN
          "arn:aws:s3:::terraform-accessible-s3-bucket-973148501077/*" # All objects in the bucket
        ]
      }
    ]
  })
}

# Attach the S3 policy to the EC2 role
resource "aws_iam_policy_attachment" "s3_policy_attachment" {
  name       = "s3-policy-attachment"
  policy_arn = aws_iam_policy.s3_read_policy.arn
  roles      = [aws_iam_role.ec2_s3_role.name]
}

# IAM Instance Profile to attach to EC2 instance
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-s3-instance-profile"
  role = aws_iam_role.ec2_s3_role.name
}
