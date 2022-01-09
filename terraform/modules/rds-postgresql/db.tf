resource "aws_db_instance" "db" {
  allocated_storage    = var.db_allocated_storage
  engine               = "postgres"
  engine_version       = var.db_postgres_version
  apply_immediately    = true
  backup_retention_period = 0
  skip_final_snapshot     = true
  instance_class       = var.db_instance_class
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = aws_db_parameter_group.db.name

  db_subnet_group_name   = aws_db_subnet_group._.name
  vpc_security_group_ids = [aws_security_group.db.id]

  # for public access limit
  publicly_accessible = var.publicly_accessible
}

resource "aws_security_group" "db" {
  name = "${var.namespace}-rds-sg"

  description = "RDS (terraform-managed)"
  vpc_id      = aws_vpc._.id
  
  /* write in here will conflict
  # Only MySQL in
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public.cidr_block]
  }

  # for public access limit
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.db_allow_ingress_ip}/32"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/32"]
  }*/
}

resource "aws_db_parameter_group" "db" {
  family = "postgres13"

  /*
  see: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraPostgreSQL.Reference.ParameterGroups.html
  parameter {
      name  = "log_bin_trust_function_creators"
      value = 1
  }
  */
}


resource "aws_security_group_rule" "db_rule_all_egress" {
  description = "Allow all outbound traffic (terraform-managed)"

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

  security_group_id = aws_security_group.db.id
}


resource "aws_security_group_rule" "db_rule_specific_ingress" {

  type              = "ingress"
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = ["${var.db_allow_ingress_ip}/32"]

  security_group_id = aws_security_group.db.id
}

resource "aws_security_group_rule" "db_rule_subnet_ingress" {

  type              = "ingress"
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = [aws_subnet.public.cidr_block]

  security_group_id = aws_security_group.db.id
}
