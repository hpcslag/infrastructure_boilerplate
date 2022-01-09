output "db_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.db.endpoint
}

output "db_address" {
  description = "The connection endpoint"
  value       = aws_db_instance.db.address
}

output "db_port" {
  description = "The database port"
  value       = aws_db_instance.db.port
}

output "db_username" {
  description = "The database username"
  value       = aws_db_instance.db.username
}

output "db_password" {
  description = "The database password"
  value       = aws_db_instance.db.password
  sensitive = true
}

output "vpc_id" {
  value       = aws_vpc._.id
}


output "vpc_route_table_id" {
  value       = aws_route_table._.id
}

output "vpc_cidr" {
  value = aws_vpc._.cidr_block
}

output "ec2_security_group_id" {
  value = aws_security_group.ec2.id
}

output "db_security_group_id" {
  value = aws_security_group.db.id
}