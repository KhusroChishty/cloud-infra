provider "aws" {
  region = "us-west-1"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "prod_vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availabilty_zone        = "us-west-1a"
  map_public_ip_on_launch = true

}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availabilty_zone        = "us-west-1b"
  map_public_ip_on_launch = true

}

resource "aws_subnet" "private_1" {
  vpc_id           = aws_vpc.main.id
  cidr_block       = "10.0.11.0/24"
  availabilty_zone = "us-west-1b"

}

resource "aws_subnet" "private_2" {
  vpc_id           = aws_vpc.main.id
  cidr_block       = "10.0.12.0/24"
  availabilty_zone = "us-west-1c"

}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip
  subnet_id     = aws_subnet.public_1.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_route_table.public_1.id
  }
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_route_table.private_1.id
  }
}

resource "aws_route_table_association" "pub_asso_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table_association" "pub_asso_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table_association" "private_asso_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_asso_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}