# Création du Security Group

resource "aws_security_group" "Aut_http" {
  name        = "Aut_http"
  description = "AUT HTTP traffic"
  vpc_id      = aws_vpc.VPC-Fargate.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AUTH_http"
  }
}
