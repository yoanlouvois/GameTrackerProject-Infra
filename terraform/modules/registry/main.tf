resource "aws_ecr_repository" "front" {
  name                 = "${var.project_name}-${var.environment}-front"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-front-ecr"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecr_repository" "back" {
  name                 = "${var.project_name}-${var.environment}-back"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-back-ecr"
    Project     = var.project_name
    Environment = var.environment
  }
}