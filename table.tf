# Création de l'Internet Gateway
resource "aws_internet_gateway" "IGW-FG" {
  vpc_id = aws_vpc.VPC-Fargate.id

  tags = {
    Name = "IGW"
  }
}

# Création de la table de routage
resource "aws_route_table" "FG-Table" {
  vpc_id = aws_vpc.VPC-Fargate.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW-FG.id
  }

  tags = {
    Name = "T_FG"
  }
}

# Association des sous-réseaux à la table de routage
resource "aws_route_table_association" "Ass1" {
  subnet_id      = aws_subnet.Sub-1.id
  route_table_id = aws_route_table.FG-Table.id
}

resource "aws_route_table_association" "Ass2" {
  subnet_id      = aws_subnet.Sub-2.id
  route_table_id = aws_route_table.FG-Table.id
}
