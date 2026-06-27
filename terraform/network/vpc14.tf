provider "aws" {
    region = "us-west-2"
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "prod-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public_1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availabilty_zone = "us-west-2a"
    map_public_ip_on_launch = true
}


resource "aws_subnet" "private_1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.11.0/24"
    availabilty_zone = "us-west-2a"
    map_public_ip_on_launch = false
}


resource "aws_eip" "nat_eip" {
    domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.eip.id
    subnet_id = aws_subnet.public_1
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}


resource "aws_route_table_association" "public_asso_1" {
    subnet_id = aws_subnet.public_1.id
    route_table_id = aws_route_table.public_rt.id
}