/*resource "aws_cloudwatch_event_rule" "schedule" {
  count       = var.schedule_runs ? 1 : 0
  name        = "${local.pipeline_name}-event-rule"
  description = "Run CodePipeline on a schedule."
  role_arn    = aws_iam_role.schedule[0].arn

  schedule_expression = var.schedule_expression
}

resource "aws_iam_role" "schedule" {
  count              = var.schedule_runs ? 1 : 0
  name               = "${local.pipeline_name}-schedule-runner"
  assume_role_policy = templatefile("./policies/cloudwatch_assume_policy.tpl", {})
}

resource "aws_cloudwatch_event_target" "schedule" {
  count    = var.schedule_runs ? 1 : 0
  rule     = aws_cloudwatch_event_rule.schedule[0].name
  arn      = aws_codepipeline.cd_pipeline.arn
  role_arn = aws_iam_role.schedule[0].arn
}

resource "aws_iam_role_policy" "schedule" {
  count = var.schedule_runs ? 1 : 0
  role  = aws_iam_role.schedule[0].name

  policy = templatefile("./policies/codepipeline_schedule_policy.tpl", {
    pipeline = aws_codepipeline.cd_pipeline.arn
  })
}
*/