resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.enterprise.id
  cidr_block        = "10.0.100.0/24"
  availability_zone = var.availability_zones[0]

  map_public_ip_on_launch = false

  tags = {
    Name = "enterprise-public-subnet-a"
    Tier = "Public"
  }
}
resource "aws_internet_gateway" "enterprise" {
  vpc_id = aws_vpc.enterprise.id

  tags = {
    Name = "enterprise-igw"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.enterprise.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.enterprise.id
  }

  tags = {
    Name = "enterprise-public-rt"
    Tier = "Public"
  }
}

resource "aws_route_table_association" "public_a_to_public" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "enterprise-nat-eip"
  }
}

resource "aws_nat_gateway" "public_a" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  depends_on = [aws_internet_gateway.enterprise]

  tags = {
    Name = "enterprise-nat-gateway-a"
  }
}
resource "aws_route" "employee_internet" {
  route_table_id         = aws_route_table.employee_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public_a.id
}