module "rds_cluster" {
  source = "cloudposse/rds-cluster/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version         = "0.49.2"

  engine          = var.engine
  cluster_family  = var.cluster_family
  # 1 writer, N reader
  cluster_size    = var.cluster_size
  namespace       = "eg"
  stage           = "prod"
  name            = "${var.namespace}-db"
  admin_user      = var.admin_user
  admin_password  = var.admin_password
  db_name         = var.db_name
  db_port         = 5432
  instance_type   = var.instance_type
  vpc_id          = aws_vpc._.id
  security_groups = []
  vpc_security_group_ids = [aws_security_group._.id]
  subnets         = [aws_subnet.public.id, aws_subnet.private.id]

  publicly_accessible = var.publicly_accessible

  deletion_protection = var.deletion_protection

  autoscaling_enabled = var.autoscaling_enabled

  # enable monitoring every 30 seconds
  rds_monitoring_interval = 30

  # reference iam role created above
  rds_monitoring_role_arn = aws_iam_role.enhanced_monitoring.arn

}