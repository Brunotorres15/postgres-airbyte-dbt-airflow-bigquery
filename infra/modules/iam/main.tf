
resource "aws_iam_role" "ec2_access_role" {
  name = "s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ec3_s3_access_role" {
  name = "ec3_s3_access_rol"
  role = aws_iam_role.ec2_access_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
        ]
        Effect   = "Allow"
        Resource = ["${var.bucket_arn}/*",
                    "${var.bucket_arn}"]
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_s3_access_profile" {
  name = "ec2_s3_access_profile"
  role = aws_iam_role.ec2_access_role.name
}


output "ec2_s3_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_s3_access_profile.name
}