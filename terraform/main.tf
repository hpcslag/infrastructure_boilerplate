locals {
  env          = var.env
  project_name = var.project_name
}

resource "aws_codedeploy_app" "app" {
  compute_platform = "Server"
  name             = var.project_name
}

module "deployment_group" {
    source = "./modules/deployment_group"
    count = length(var.environments)
    deployment_group_name = var.environments[count.index]
    app_name = aws_codedeploy_app.app.name
}

##########################################
# S3 Staging, Production 及 Pipeline  
#########################################

module "web" {
  source = "./modules/web"

  count = length(var.environments)

  env          = var.environments[count.index] # local.env
  project_name = local.project_name

  # production has no prefix, so other will be i.e. staging+"."+"xxxx.com" <- prod_domain_name
  domain_name = var.environments[count.index] == "production" ? var.production_domain_name : "${var.environments[count.index]}.${var.production_domain_name}"
}

module "web_pipeline" {
  source = "./modules/pipeline"

  count = length(var.environments)

  name         = "web"
  env          = var.environments[count.index] # local.env
  project_name = "${local.project_name}-web-${var.environments[count.index]}"
  aws_region   = var.aws_region

  repository_name = var.codecommit_website # Use custom name
  git_branch      = var.environments[count.index]

  #                      staging_web is "staging_web" module pointer
  cloudfront_distribution = module.web[count.index].cloudfront_distribution
  s3_bucket               = module.web[count.index].s3_bucket

  # each enviroment has their own build command, setup for frontend build task.
  deploy_script_env = "deploy:${var.environments[count.index]}"
}
