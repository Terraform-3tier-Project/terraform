output "bucket_name" {
  value = aws_s3_bucket.codedeploy_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.codedeploy_bucket.arn
}

output "bucket_regional_domain_name" {
  description = "The regional domain name of the S3 bucket"
  value       = aws_s3_bucket.codedeploy_bucket.bucket_regional_domain_name
}
