resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.public_availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-learning-public-subnet"
  }
}