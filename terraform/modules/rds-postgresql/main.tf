resource "aws_instance" "_" {
  ami                    = "ami-0f6565c3d5328c913" # <- ap-southeast-1 us-east-2: "ami-0b29b6e62f2343b46" // AMI: ubuntu iso id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2.id]
  subnet_id              = aws_subnet.public.id
  iam_instance_profile   = aws_iam_instance_profile._.name

  tags = {
    Name                = var.namespace
    DeploymentGroupName = var.namespace
  }

  root_block_device {
    volume_size = 10 // EC2 instance size up to 20GB
  }
}

resource "aws_eip" "_" {
  instance = aws_instance._.id
  vpc      = true
}
