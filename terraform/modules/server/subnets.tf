resource "aws_subnet" "private" {
  vpc_id            = aws_vpc._.id
  cidr_block        = "${var.vpc_cidr_prefix16}.0.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "${var.namespace}-private-subnet"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc._.id
  cidr_block        = "${var.vpc_cidr_prefix16}.1.0/24"
  availability_zone = "ap-southeast-1c"

  tags = {
    Name = "${var.namespace}-public-subnet"
  }
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
