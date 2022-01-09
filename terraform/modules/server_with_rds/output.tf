output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = aws_instance._.public_ip // if is multiple with count then use aws_instance._.*.public_ip
}

output "namespace" {
  value       = aws_instance._.tags.Name // if is multiple with count then use aws_instance._.*.public_ip
}