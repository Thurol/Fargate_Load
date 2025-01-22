# Création des sous-réseaux publics

resource "aws_subnet" "Sub-1" {
  vpc_id     = aws_vpc.VPC-Fargate.id
  cidr_block = "10.8.1.0/24"
  availability_zone = "us-east-1a"

}

resource "aws_subnet" "Sub-2" {
  vpc_id     = aws_vpc.VPC-Fargate.id
  cidr_block = "10.8.2.0/24"
  availability_zone = "us-east-1b"

}
