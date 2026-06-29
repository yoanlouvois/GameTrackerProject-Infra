output "front_repository_url" {
  value = aws_ecr_repository.front.repository_url
}

output "back_repository_url" {
  value = aws_ecr_repository.back.repository_url
}

output "front_repository_arn" {
  value = aws_ecr_repository.front.arn
}

output "back_repository_arn" {
  value = aws_ecr_repository.back.arn
}