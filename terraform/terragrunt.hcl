locals {
  env         = get_env("ENV", "production")
  common_vars = yamldecode(file("./vars/common.yml"))
  secrets     = merge(local.common_vars, yamldecode(file("./vars/${local.env}.yml")))
  aws_region  = local.secrets.aws_region
  aws_profile = local.secrets.aws_profile
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-state-${local.secrets.project_name}-${local.env}-${local.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    profile        = local.aws_profile
    region         = local.aws_region
    dynamodb_table = "terraform-locks"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  profile = "${local.aws_profile}"
}

terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

EOF
}

inputs = merge(
  local.secrets,
  {
    env = local.env
  }
)


