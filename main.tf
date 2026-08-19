terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terraform-learning-vpc"
  }

}

resource "aws_subnet" "public"{
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-learning-public-subnet"
  }

}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-2b"

  tags = {
    Name = "terraform-learning-private-subnet"
  }
}

