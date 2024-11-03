# S3 backend for EKS
terraform {
  backend "s3" {
    region         = "eu-west-1"
    bucket         = "your-state-s3-bucket"
    key            = "statefiles/EKS/staging-env.tfstate"
    acl            = "private"
    encrypt        = true
  }
}