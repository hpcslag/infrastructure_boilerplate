output "s3_bucket" {
  value = aws_s3_bucket.web
}

output "cloudfront_distribution" {
  value = aws_cloudfront_distribution.web
}
