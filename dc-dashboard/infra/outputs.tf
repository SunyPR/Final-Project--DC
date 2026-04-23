output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

# Este output te dará el link final para el profesor
output "dashboard_url" {
  value = "Revisa la consola de AWS para el DNS del Application Load Balancer"
}