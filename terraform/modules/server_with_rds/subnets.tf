resource "aws_subnet" "private" {
  vpc_id            = aws_vpc._.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "${var.namespace}-private-subnet"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc._.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1c"

  tags = {
    Name = "${var.namespace}-public-subnet"
  }
}

resource "aws_db_subnet_group" "_" {
  name = "${var.namespace}-subnet-group"

  subnet_ids = [
    aws_subnet.private.id,
    aws_subnet.public.id
  ]

  tags = {
    Name = "${var.namespace}-subnet-group"
  }
}

output "subnet_group" {
  value = aws_db_subnet_group._
}

output "public_subnets" {
  value = [
    aws_subnet.public
  ]
}

output "private_subnets" {
  value = [
    aws_subnet.private
  ]
}
