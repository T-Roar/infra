
resource "aws_route_table" "route_table" {
  for_each = var.vpc_config

  vpc_id = aws_vpc.vpc[each.key].id

  tags = {
    Name = "${each.value.vpc_name}-route-table"
  }
}

resource "aws_eip" "nat_eip" {
  for_each = var.vpc_config

  domain = "vpc"
}


resource "aws_route_table" "private_route_table" {
  for_each = var.vpc_config

  vpc_id = aws_vpc.vpc[each.key].id

  tags = {
    Name = "${each.value.vpc_name}-private_route_table"
  }
}

resource "aws_route" "private_route" {
  for_each = aws_subnet.private_subnet

  route_table_id         = aws_route_table.private_route_table[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[each.key].id
}

resource "aws_nat_gateway" "nat_gateway" {
  for_each = var.vpc_config

  subnet_id     = aws_subnet.subnet[each.key].id
  allocation_id = aws_eip.nat_eip[each.key].id
}

resource "aws_internet_gateway" "int" {
  for_each = var.vpc_config

  vpc_id = aws_vpc.vpc[each.key].id
}
