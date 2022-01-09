resource "aws_security_group" "ec2" {
  name = "${var.namespace}-ec2-sg"

  description = "EC2 security group (terraform-managed)"
  vpc_id      = aws_vpc._.id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    description = "all traffic access from local"
    cidr_blocks = var.all_traffic_cidrs
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    description = "Graph-Node"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8020
    to_port     = 8020
    protocol    = "tcp"
    description = "Graph-Node-JSON-RPC"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8030
    to_port     = 8030
    protocol    = "tcp"
    description = "Graph-Node-Index-Node"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8040
    to_port     = 8040
    protocol    = "tcp"
    description = "Graph-Node-Metric-Server"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    description = "Graph-Node-WebSocket"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    description = "Graph-Node-IPFS"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # access db only allow that in same VPC
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    description = "MySQL"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS"
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
