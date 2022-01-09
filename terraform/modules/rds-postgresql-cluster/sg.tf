resource "aws_security_group" "_" {
  name = "${var.namespace}-rds-cluster-sg"

  description = "RDS security group (terraform-managed)"
  vpc_id      = aws_vpc._.id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    description = "all traffic access from local"
    cidr_blocks = var.all_traffic_cidrs
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    description = "PostgreSQL"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
