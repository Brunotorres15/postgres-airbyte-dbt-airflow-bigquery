resource "aws_s3_bucket" "astro_dbt_bucket" {
  bucket = var.bucket_name

  force_destroy = true

  tags = {
    Name        = "Bucket para armazenar as Dags do Airflow e os scripts DBT"
    Environment = "Scripts"
  }
}

resource "aws_s3_bucket_public_access_block" "blocket_public_access" {
  bucket = aws_s3_bucket.astro_dbt_bucket.id

  block_public_policy     = true

  restrict_public_buckets = true
}

output "bucket_arn" {
 value = aws_s3_bucket.astro_dbt_bucket.arn
}