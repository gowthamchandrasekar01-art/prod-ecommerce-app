resource "aws_internet_gateway" "prod_ecommerce" {
  vpc_id = aws_vpc.prod_ecommerce.id

  tags = {
    Name = "prod-ecommerce-igw"
  }
}
