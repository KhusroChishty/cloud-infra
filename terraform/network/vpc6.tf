provider "aws" {
  alias  = "west_2_6"
  region = "us-west-2"
}

resource "aws_vpc" "main_6" {
  provider = aws.west_2_6

  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Prod-vpc"
  }
}

resource "aws_internet_gateway" "igw_6" {
  provider = aws.west_2_6

  vpc_id = aws_vpc.main_6.id
}

resource "aws_subnet" "public_6_1" {
  provider = aws.west_2_6

  vpc_id                  = aws_vpc.main_6.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_6_2" {
  provider = aws.west_2_6

  vpc_id                  = aws_vpc.main_6.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_6_1" {
  provider = aws.west_2_6

  vpc_id                  = aws_vpc.main_6.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private_6_2" {
  provider = aws.west_2_6

  vpc_id                  = aws_vpc.main_6.id
  cidr_block              = "10.0.12.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = false
}

resource "aws_eip" "nat_eip_6" {
  provider = aws.west_2_6

  domain = "vpc"

  depends_on = [
    aws_internet_gateway.igw_6
  ]
}

resource "aws_nat_gateway" "nat_6" {
  provider = aws.west_2_6

  allocation_id = aws_eip.nat_eip_6.id
  subnet_id     = aws_subnet.public_6_1.id

  depends_on = [
    aws_internet_gateway.igw_6
  ]
}

resource "aws_route_table" "public_rt_6" {
  provider = aws.west_2_6

  vpc_id = aws_vpc.main_6.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_6.id
  }
}

resource "aws_route_table" "private_rt_6" {
  provider = aws.west_2_6

  vpc_id = aws_vpc.main_6.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_6.id
  }
}

resource "aws_route_table_association" "public_6_assoc_1" {
  provider = aws.west_2_6

  subnet_id      = aws_subnet.public_6_1.id
  route_table_id = aws_route_table.public_rt_6.id
}

resource "aws_route_table_association" "public_6_assoc_2" {
  provider = aws.west_2_6

  subnet_id      = aws_subnet.public_6_2.id
  route_table_id = aws_route_table.public_rt_6.id
}

resource "aws_route_table_association" "private_6_assoc_1" {
  provider = aws.west_2_6

  subnet_id      = aws_subnet.private_6_1.id
  route_table_id = aws_route_table.private_rt_6.id
}

resource "aws_route_table_association" "private_6_assoc_2" {
  provider = aws.west_2_6

  subnet_id      = aws_subnet.private_6_2.id
  route_table_id = aws_route_table.private_rt_6.id
}
