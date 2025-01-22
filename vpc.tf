# Création du VPC

resource "aws_vpc" "VPC-Fargate" {
  cidr_block = "10.8.0.0/16"
  tags = {
    Name = "Fargate-VPC"
  }
}
