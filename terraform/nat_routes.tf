resource "aws_route" "app_a_nat" {
  route_table_id         = aws_route_table.app_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_a.id
}

resource "aws_route" "app_b_nat" {
  route_table_id         = aws_route_table.app_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_b.id
}
