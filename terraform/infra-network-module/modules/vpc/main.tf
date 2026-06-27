resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({
    Name        = "${var.name}-${var.environment}-vpc"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge({
    Name        = "${var.name}-${var.environment}-igw"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  for_each = { for idx, az in zipmap(range(length(var.azs)), var.azs) : idx => az }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[each.key]
  availability_zone       = each.value
  map_public_ip_on_launch = true

  tags = merge({
    Name        = "${var.name}-${var.environment}-public-${each.value}"
    Environment = var.environment
    Tier        = "public"
    ManagedBy   = "terraform"
  }, var.tags)
}

resource "aws_subnet" "private" {
  for_each = { for idx, az in zipmap(range(length(var.azs)), var.azs) : idx => az }

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[each.key]
  availability_zone = each.value

  tags = merge({
    Name        = "${var.name}-${var.environment}-private-${each.value}"
    Environment = var.environment
    Tier        = "private"
    ManagedBy   = "terraform"
  }, var.tags)
}

resource "aws_eip" "nat" {
  for_each = aws_subnet.public
  vpc      = true

  tags = merge({
    Name        = "${var.name}-${var.environment}-nat-eip-${each.key}"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

resource "aws_nat_gateway" "this" {
  for_each = aws_subnet.public

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id

  tags = merge({
    Name        = "${var.name}-${var.environment}-nat-${each.key}"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge({
    Name        = "${var.name}-${var.environment}-public-rt"
    Environment = var.environment
    Tier        = "public"
    ManagedBy   = "terraform"
  }, var.tags)
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge({
    Name        = "${var.name}-${var.environment}-private-rt"
    Environment = var.environment
    Tier        = "private"
    ManagedBy   = "terraform"
  }, var.tags)
}

resource "aws_route" "private" {
  for_each = aws_subnet.private

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
