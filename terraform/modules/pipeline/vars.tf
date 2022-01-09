variable "name" {
  type = string
}

variable "env" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "git_branch" {
  type = string
}

variable "s3_bucket" {}
variable "cloudfront_distribution" {}

variable "deploy_script_env" {
  type = string
}
