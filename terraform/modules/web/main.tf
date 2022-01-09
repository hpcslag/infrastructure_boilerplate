locals {
  web_bucket_name = "${var.domain_name}"
  s3_origin_id    = "${local.web_bucket_name}-origin"
}

resource "aws_s3_bucket" "web" {
  bucket = local.web_bucket_name

  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}

resource "aws_s3_bucket_policy" "web" {
  bucket = aws_s3_bucket.web.id

  policy = templatefile("./policies/public_bucket_policy.tpl", {
    s3_bucket = aws_s3_bucket.web.arn
  })
}

resource "aws_cloudfront_distribution" "web" {
  origin {
    domain_name = replace(aws_s3_bucket.web.bucket_regional_domain_name, ".s3.", ".s3-website.")
    origin_id   = local.s3_origin_id

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled = true

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }
}
