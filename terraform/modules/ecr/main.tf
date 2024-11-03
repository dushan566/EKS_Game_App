
resource "aws_ecr_repository" "ecr_repo" {
  name                 = lower("${var.application}-ecr-repo")
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}