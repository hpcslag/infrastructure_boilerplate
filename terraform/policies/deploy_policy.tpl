{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Resource": ${jsonencode(repos)},
      "Action": [
        "codecommit:GitPull"
      ]
    }
  ]
}
