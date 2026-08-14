resource "aws_vpc" "prod_ecommerce" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = false

  tags = {
    Name = "prod-ecommerce-vpc"
  }
}
