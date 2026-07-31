variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "eu_availability_zone" {}
variable "cidr_private_subnet" {}

output "forever_vpc_id" {
  value = aws_vpc.forever_vpc_eu_central_1.id
}

output "forever_public_subnets" {
  value = aws_subnet.forever_public_subnets.*.id
}

output "forever_private_subnets" {
  value = aws_subnet.forever_private_subnets.*.id
}

output "public_subnet_cidr_block" {
  value = aws_subnet.forever_public_subnets.*.cidr_block
}

# Setup VPC
resource "aws_vpc" "forever_vpc_eu_central_1" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}


# Setup public subnet
resource "aws_subnet" "forever_public_subnets" {
  count             = length(var.cidr_public_subnet)
  vpc_id            = aws_vpc.forever_vpc_eu_central_1.id
  cidr_block        = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name = "forever-public-subnet-${count.index + 1}"
  }
}

# Setup private subnet
resource "aws_subnet" "forever_private_subnets" {
  count             = length(var.cidr_private_subnet)
  vpc_id            = aws_vpc.forever_vpc_eu_central_1.id
  cidr_block        = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name = "forever-private-subnet-${count.index + 1}"
  }
}

# Setup Internet Gateway
resource "aws_internet_gateway" "forever_public_internet_gateway" {
  vpc_id = aws_vpc.forever_vpc_eu_central_1.id
  tags = {
    Name = "forever-igw"
  }
}

# Public Route Table
resource "aws_route_table" "forever_public_route_table" {
  vpc_id = aws_vpc.forever_vpc_eu_central_1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.forever_public_internet_gateway.id
  }
  tags = {
    Name = "forever-public-rt"
  }
}

# Public Route Table and Public Subnet Association
resource "aws_route_table_association" "forever_public_rt_subnet_association" {
  count          = length(aws_subnet.forever_public_subnets)
  subnet_id      = aws_subnet.forever_public_subnets[count.index].id
  route_table_id = aws_route_table.forever_public_route_table.id
}

# Private Route Table
resource "aws_route_table" "forever_private_subnets" {
  vpc_id = aws_vpc.forever_vpc_eu_central_1.id
  #depends_on = [aws_nat_gateway.nat_gateway]
  tags = {
    Name = "forever-private-rt"
  }
}

# Private Route Table and private Subnet Association
resource "aws_route_table_association" "forever_private_rt_subnet_association" {
  count          = length(aws_subnet.forever_private_subnets)
  subnet_id      = aws_subnet.forever_private_subnets[count.index].id
  route_table_id = aws_route_table.forever_private_subnets.id
}

# NAT access for private EKS nodes to reach AWS APIs and container registries
resource "aws_eip" "forever_nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "forever_nat" {
  allocation_id = aws_eip.forever_nat.id
  subnet_id     = aws_subnet.forever_public_subnets[0].id

  depends_on = [aws_internet_gateway.forever_public_internet_gateway]
}

resource "aws_route" "forever_private_nat_route" {
  route_table_id         = aws_route_table.forever_private_subnets.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.forever_nat.id
}