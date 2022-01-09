output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = aws_instance._.public_ip // if is multiple with count then use aws_instance._.*.public_ip
}

output "namespace" {
  value       = aws_instance._.tags.Name // if is multiple with count then use aws_instance._.*.public_ip
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

output "private_ip" {
  value = aws_instance._.private_ip
}