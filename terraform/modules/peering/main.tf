# this is for peer to EKS or other service
# https://dev.to/bensooraj/accessing-amazon-rds-from-aws-eks-2pc3

// this module will help you create the sg rule, so careful dont duplicated the cidr traffic rule

// careful sometime it will not create successfully and didn't tell you, must apply twice to apply it

// https://stackoverflow.com/questions/54596521/terraform-deletes-route-tables-then-adds-them-on-second-run-no-changes-bug-or

resource "aws_vpc_peering_connection" "PEER_A2B" {
  
  peer_vpc_id   = var.peer_vpc_id
  vpc_id        = var.this_vpc_id # acceptor is us

  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

# bind to existsed rotuer table 

# aws router (e.g rds to eks)
resource "aws_route" "A2B" {
  count = length(var.this_vpc_route_table_ids)
  
  # this
  route_table_id            = var.this_vpc_route_table_ids[count.index]

  # to b
  destination_cidr_block    = var.peer_vpc_cidr

  vpc_peering_connection_id = aws_vpc_peering_connection.PEER_A2B.id
}

# aws router (e.g eks to rds)
resource "aws_route" "B2A" {
  count = length(var.peer_vpc_route_table_ids)

  # peer
  route_table_id            = var.peer_vpc_route_table_ids[count.index]

  # to a
  destination_cidr_block    = var.this_vpc_cidr

  vpc_peering_connection_id = aws_vpc_peering_connection.PEER_A2B.id
}

# These may cause aws_security_group_rule everytime modify needs to apply two time...  (WARNING)
resource "aws_security_group_rule" "A" {
  description = "Peering Config A (terraform-managed)"
  # count = length([var.peer_vpc_cidr]) could be more but only do once now

  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.peer_vpc_cidr]
  security_group_id = var.this_vpc_security_group_id
}

// InvalidPermission.Duplicate: because everyone apply the same rule
resource "aws_security_group_rule" "B" {
  description = "Peering Config B (terraform-managed)"
  # count = length(var.this_vpc_cidr) could be more but only do once now

  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.this_vpc_cidr]
  security_group_id = var.peer_vpc_security_group_id
}