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