# Elastic IPs para NAT Gateways
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? length(var.public_subnet_cidrs) : 0

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
      Type = "ElasticIP"
    }
  )

  depends_on = [var.internet_gateway_id]
}

# Subnets Públicas
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
      Type = "PublicSubnet"
      Tier = "Public"
    }
  )
}

# Subnets Privadas
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
      Type = "PrivateSubnet"
      Tier = "Private"
    }
  )
}

# Subnets de Banco de Dados
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)

  vpc_id            = var.vpc_id
  cidr_block        = var.database_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-database-subnet-${count.index + 1}"
      Type = "DatabaseSubnet"
      Tier = "Database"
    }
  )
}

# NAT Gateways (um por subnet pública)
resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway ? length(aws_subnet.public) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-nat-gateway-${count.index + 1}"
      Type = "NATGateway"
    }
  )

  depends_on = [var.internet_gateway_id]
}
