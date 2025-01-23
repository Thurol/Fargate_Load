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

# 4. Application Load Balancer

resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Aut_http.id]
  subnets            = [aws_subnet.Sub-1.id, aws_subnet.Sub-2.id]
}

resource "aws_lb_target_group" "app_tg" {
  name        = "app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.VPC-Fargate.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "300"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Service ECS
resource "aws_ecs_service" "app_service" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.Cluster_Farg1.id
  task_definition = aws_ecs_task_definition.Farg_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.Sub-1.id, aws_subnet.Sub-2.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.Aut_http.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "app-container"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.front_end]
}
