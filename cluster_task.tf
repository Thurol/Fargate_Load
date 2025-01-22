# 3. Cluster Fargate et Task Definition

resource "aws_ecs_cluster" "Cluster_Farg1" {
  name = "Farg1-cluster"
}

resource "aws_ecs_task_definition" "Farg_task" {
  family                   = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::591688565785:role/LabRole"
  

  container_definitions = jsonencode([{
    name  = "app-container"
    image = "591688565785.dkr.ecr.us-east-1.amazonaws.com/apps_fargate:latest"
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}
