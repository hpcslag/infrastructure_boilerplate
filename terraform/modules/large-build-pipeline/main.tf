locals {
  pipeline_name          = "${var.project_name}-${var.env}-${var.name}-pipeline"
  codebuild_project_name = "${var.project_name}-${var.env}-${var.name}-build"
  codepipeline_role_name = "${local.pipeline_name}-service-role"
  codebuild_role_name    = "${local.codebuild_project_name}-service-role"
  artifact_bucket_name   = "${local.pipeline_name}-artifacts"
}

resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket = local.artifact_bucket_name

  lifecycle_rule {
    id      = "artifacts"
    enabled = true

    expiration {
      days = 1
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name = local.codepipeline_role_name

  assume_role_policy = templatefile("./policies/codepipeline_assume_policy.tpl", {})
}

resource "aws_iam_role_policy" "codepipeline_role" {
  name = "${local.codepipeline_role_name}-policy"

  role = aws_iam_role.codepipeline_role.id

  policy = templatefile("./policies/codepipeline_policy.tpl", {})
}

resource "aws_iam_role" "codebuild_role" {
  name               = local.codebuild_role_name
  assume_role_policy = templatefile("./policies/build_role_assume_policy.tpl", {})
}

resource "aws_iam_role_policy" "codebuild_role" {
  name = "${local.codebuild_role_name}-policy"
  role = aws_iam_role.codebuild_role.id
  policy = templatefile("./policies/build_role_policy.tpl", {
    public_bucket   = var.s3_bucket.arn
    aws_region      = var.aws_region
    artifact_bucket = aws_s3_bucket.pipeline_artifacts.arn
  })
}

resource "aws_codebuild_project" "_" {
  name         = local.codebuild_project_name
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type            = "CODEPIPELINE"
    git_clone_depth = 0
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_CUSTOM_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_LARGE"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    privileged_mode             = true

    dynamic "environment_variable" {
      for_each = merge(var.additional_build_env_vars, {
        name  = "STATIC_ASSETS_BUCKET"
        value = var.s3_bucket.bucket
      })
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }

  }
}

resource "aws_codepipeline" "cd_pipeline" {
  name     = local.pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.pipeline_artifacts.bucket
  }

  stage {
    name = "Source"

    action {
      category        = "Source"
      owner           = "AWS"
      provider        = "CodeCommit"
      input_artifacts = []
      name            = "Source"
      output_artifacts = [
        "SourceArtifact"
      ]
      run_order = 1
      version   = "1"

      configuration = {
        "RepositoryName"       = var.repository_name # use custom name of repo
        "BranchName"           = var.git_branch
        "PollForSourceChanges" = true
      }
    }
  }

  stage {
    name = "Build"

    action {
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      configuration = {
        "ProjectName" = aws_codebuild_project._.name
      }
      input_artifacts = [
        "SourceArtifact"
      ]
      output_artifacts = [
        "BuildArtifact"
      ]
      name             = "Build"
      run_order        = 1
      version          = "1"
    }
  }

  stage {
    name = "Deploy"

    action {
      name     = "Deploy"
      category = "Deploy"
      owner    = "AWS"
      provider = "CodeDeploy"

      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        "ApplicationName"     = var.codedeploy_app_name
        "DeploymentGroupName" = var.deployment_group_name
      }
    }
  }
}

