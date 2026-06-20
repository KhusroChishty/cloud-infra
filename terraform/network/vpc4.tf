provider "aws" {
  region = us-west-2
}

resource "aws_vpc" "prod" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "prod-vpc"
  }
}


# ======================
# Internet Gateway
# ======================


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prod.id

  tags = {
    Name = "prod-igw"
  }
}

# ======================
# Public Subnets
# ======================

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.prod.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "prod"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.prod.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "prod"
  }
}

# ======================
# Private Subnets
# ======================



resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "prod"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "prod"
  }
}


# ======================
# Elastic IP for NAT
# ======================



resource "aws_eip" "nat_id" {
  domain = "vpc"
}


# ======================
# NAT Gateway
# ======================


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_id.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "Prod"
  }
}

# ======================
# Public Route Table
# ======================


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.prod.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}


# ======================
# Public Route Associations
# ======================


resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}



resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.prod.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}
