provider "aws" { region = "us-east-1" }

# 1. ECR Repository para tu imagen Docker
resource "aws_ecr_repository" "app_repo" { name = "dc-dashboard-repo" }

# 2. ECS Cluster
resource "aws_ecs_cluster" "main" { name = "dc-ops-cluster" }

# 3. Fargate Task Definition (Usa 0.25 vCPU y 0.5GB RAM para ahorrar)
resource "aws_ecs_task_definition" "app" {
  family                   = "dc-ops-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  container_definitions    = jsonencode([{
    name      = "dc-dashboard"
    image     = "${aws_ecr_repository.app_repo.repository_url}:latest"
    portMappings = [{ containerPort = 8501, hostPort = 8501 }]
  }])
}

# Nota: Necesitarás configurar el Application Load Balancer (ALB) y los Security Groups
# para que el link sea accesible públicamente.