provider "aws" {
  region = "us-east-1"
}

# --- 1. ECR Repository ---
resource "aws_ecr_repository" "app_repo" {
  name                 = "dc-dashboard-repo"
  image_tag_mutability = "MUTABLE"
}

# --- 2. ECS Cluster ---
resource "aws_ecs_cluster" "main" {
  name = "dc-ops-cluster"
}

# --- 3. IAM Role for Fargate ---
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole-dc-ops"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# --- 4. ECS Task Definition ---
resource "aws_ecs_task_definition" "app" {
  family                   = "dc-ops-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name  = "dc-dashboard"
    image = "${aws_ecr_repository.app_repo.repository_url}:latest"
    portMappings = [{
      containerPort = 8501
      hostPort      = 8501
    }]
  }])
}

# --- 5. Networking (Default VPC) ---
resource "aws_default_vpc" "default" {}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

# --- 6. Security Groups ---
resource "aws_security_group" "alb_sg" {
  name   = "dc-ops-alb-sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
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
}

resource "aws_security_group" "ecs_sg" {
  name   = "dc-ops-ecs-sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port       = 8501
    to_port         = 8501
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- 7. Application Load Balancer (ALB) ---
resource "aws_lb" "app_alb" {
  name               = "dc-ops-alb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "app_tg" {
  name        = "dc-ops-tg"
  port        = 8501
  protocol    = "HTTP"
  vpc_id      = aws_default_vpc.default.id
  target_type = "ip"

  health_check {
    path                = "/healthz"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# --- 8. ECS Service ---
resource "aws_ecs_service" "app_service" {
  name            = "dc-ops-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "dc-dashboard"
    container_port   = 8501
  }

  depends_on = [aws_lb_listener.app_listener]
}

# --- 9. Output URL ---
output "dashboard_url" {
  value       = "http://${aws_lb.app_alb.dns_name}"
  description = "Este es el enlace público para la entrega."
}