
resource "aws_vpc" "vpc" {
  for_each = var.vpc_config

  cidr_block = each.value.cidr_block
  tags = {
    Name = each.value.vpc_name
  }

}

resource "aws_subnet" "subnet" {
  for_each = var.vpc_config

  vpc_id                  = aws_vpc.vpc[each.key].id
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = cidrsubnet(each.value.cidr_block, 8, 0)
  map_public_ip_on_launch = true

  tags = {
    Name = "${each.value.vpc_name}-subnet-${each.key}"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = var.vpc_config

  vpc_id                  = aws_vpc.vpc[each.key].id
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = cidrsubnet(each.value.cidr_block, 8, 1)
  map_public_ip_on_launch = true

  tags = {
    Name = "${each.value.vpc_name}-private_subnet-${each.key}"
  }

}

# resource "aws_subnet" "db_subnet" {
#   for_each = var.dbsubnet_config

#   vpc_id            = aws_vpc.vpc[each.key].id
#   availability_zone = data.aws_availability_zones.available.names[0]
#   cidr_block        = cidrsubnet(each.value.cidr_block, 8, 2)

#   tags = {
#     Name = "db_subnet-${each.key}"
#   }
# }

resource "aws_subnet" "db_subnet" {
  for_each = var.dbsubnet_config

  vpc_id            = aws_vpc.vpc[each.key].id
  cidr_block        = each.value.cidr_block
  availability_zone = element(slice(data.aws_availability_zones.available.names, 0, 2), index(keys(var.dbsubnet_config), each.key) % 2)

  tags = {
    Name = "db_subnet-${each.key}"
  }
}


