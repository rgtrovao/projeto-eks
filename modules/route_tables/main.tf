# Route Table para Subnets Públicas
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-public-rt"
      Type = "PublicRouteTable"
      Tier = "Public"
    }
  )
}

# Associação das Subnets Públicas com a Route Table Pública
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_ids)

  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# Route Tables para Subnets Privadas (uma por subnet para alta disponibilidade)
resource "aws_route_table" "private" {
  count = length(var.private_subnet_ids)

  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.enable_nat_gateway && length(var.nat_gateway_ids) > 0 ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = var.nat_gateway_ids[count.index % length(var.nat_gateway_ids)]
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-private-rt-${count.index + 1}"
      Type = "PrivateRouteTable"
      Tier = "Private"
    }
  )
}

# Associação das Subnets Privadas com suas Route Tables
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_ids)

  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private[count.index].id
}

# Route Tables para Subnets de Banco de Dados (sem rota para internet)
resource "aws_route_table" "database" {
  count = length(var.database_subnet_ids)

  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-database-rt-${count.index + 1}"
      Type = "DatabaseRouteTable"
      Tier = "Database"
    }
  )
}

# Associação das Subnets de Banco de Dados com suas Route Tables
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_ids)

  subnet_id      = var.database_subnet_ids[count.index]
  route_table_id = aws_route_table.database[count.index].id
}
