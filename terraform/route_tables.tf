resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.prod_ecommerce.id

  tags = {
    Name = "prod-public-a-rt"
  }
}

resource "aws_route_table" "public_b" {
  vpc_id = aws_vpc.prod_ecommerce.id

  tags = {
    Name = "prod-public-b-rt"
  }
}

resource "aws_route_table" "app_a" {
  vpc_id = aws_vpc.prod_ecommerce.id

  tags = {
    Name = "prod-app-a-rt"
  }
}

resource "aws_route_table" "app_b" {
  vpc_id = aws_vpc.prod_ecommerce.id

  tags = {
    Name = "prod-app-b-rt"
  }
}

resource "aws_route_table" "db_a" {
  vpc_id = aws_vpc.prod_ecommerce.id

  tags = {
    Name = "prod-db-a-rt"
  }
}

resource "aws_route_table" "db_b" {
  vpc_id = aws_vpc.prod_ecommerce.id

  tags = {
    Name = "prod-db-b-rt"
  }
}
