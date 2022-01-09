resource "aws_db_instance" "db" {
  allocated_storage    = var.db_allocated_storage
  engine               = "mysql"
  engine_version       = var.db_mysql_version
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
  
  # Only MySQL in
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public.cidr_block]
  }

  # for public access limit
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.db_allow_ingress_ip}/32"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/32"]
  }
}

resource "aws_db_parameter_group" "db" {
  family = "mysql8.0"

  parameter {
    name  = "log_bin_trust_function_creators"
    value = 1
  }
}
