{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:List*",
        "s3:GetObject"
      ],
      "Resource": "${s3_bucket}/*",
      "Principal": "*"
    }
  ]
}

