resource "aws_subnet" "public_subnet1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = var.public_subnet1_cidr
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet1 in AZ ${var.region}a"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = var.public_subnet2_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"
  tags = {
    Name = "Public Subnet2 in AZ ${var.region}b"
  }
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "${var.environment}-igw"
    Environment = "${var.environment}"
  }
}


resource "aws_route_table" "public1" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}
resource "aws_route" "route1" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
  route_table_id         = aws_route_table.public1.id
}

/* Route table associations with subnets*/
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public1.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public1.id
}