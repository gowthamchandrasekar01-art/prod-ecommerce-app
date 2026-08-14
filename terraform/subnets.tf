resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.prod_ecommerce.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "prod-public-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.prod_ecommerce.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "prod-public-b"
  }
}

resource "aws_subnet" "app_a" {
  vpc_id                  = aws_vpc.prod_ecommerce.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "prod-app-a"
  }
}

resource "aws_subnet" "app_b" {
  vpc_id                  = aws_vpc.prod_ecommerce.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "prod-app-b"
  }
}

resource "aws_subnet" "db_a" {
  vpc_id                  = aws_vpc.prod_ecommerce.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "prod-db-a"
  }
}

resource "aws_subnet" "db_b" {
  vpc_id                  = aws_vpc.prod_ecommerce.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "prod-db-b"
  }
}
