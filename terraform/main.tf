provider "aws" {
  region = var.region
}

# Setting up VPC and it's components
module "vpc" {
  source = "./modules/vpc"
  application = var.application
  availability_zones = var.availability_zones
  environment = var.environment
  vpc_cidr_block = var.vpc_cidr_block
  subnet_cidr_blocks = var.subnet_cidr_blocks
  tags = var.tags
}

# Setting up EKS cluster
module "eks_cluster" {
  source = "./modules/eks_cluster"
  #account-id        = var.account-id
  application       = var.application
  environment       = var.environment
  cluster_version   = var.cluster_version
  eks-kms-key-deletion-window = var.eks-kms-key-deletion-window
#  subnet_ids        = module.vpc.app_subnet_ids
  lb_subnet_ids     = module.vpc.lb_subnet_ids
  app_subnet_ids    = module.vpc.app_subnet_ids
  db_subnet_ids     = module.vpc.db_subnet_ids
  service_ipv4_cidr = var.service_ipv4_cidr
  groups_claim      = var.groups_claim
  username_claim    = var.username_claim
  tags              = var.tags
}

# Setting up EKS node group
module "eks_cluster_node_group" {
  source = "./modules/eks_node_group"
  application           = var.application
  environment           = var.environment
  subnet_ids            = module.vpc.app_subnet_ids
  aws_eks_cluster_name  = module.eks_cluster.cluster_name
  ami_type              = var.ami_type
  disk_size             = var.disk_size
  instance_types        = var.instance_types
  capacity_type         = var.capacity_type
  tags                  = var.tags
  labels                = var.labels
}

# Assign IAM users to EKS cluster based on role 
module "eks_users" {
  source = "./modules/eks_iam_access"
  application = var.application
  environment = var.environment
  tags = var.tags
}

