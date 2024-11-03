
# Create KMS scret key for cluster encryption
# --------------------------------------------------------------------------
resource "aws_kms_key" "eks_kms_key" {
  description             = "${var.application}-${var.environment}-KMS-key"
  deletion_window_in_days = var.eks-kms-key-deletion-window
  tags = var.tags
}

resource "aws_kms_alias" "kms_alias" {
  name             = "alias/${var.application}-${var.environment}-KMS-key"
  target_key_id = aws_kms_key.eks_kms_key.key_id
}



# Create EKS IAM Role
# --------------------------------------------------------------------------
module "eks_iam_role" {
  source = "../../modules/iam_role"
  application = var.application
  environment = var.environment
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_for_eks_cluster.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]
  custom_policies = [
    data.aws_iam_policy_document.AmazonEKS_EBS_CSI_Driver_Policy.json,
    data.aws_iam_policy_document.Cluster_Encryption_policy.json,
    data.aws_iam_policy_document.cloudwatch_metrics.json,
    data.aws_iam_policy_document.Cluster_ELB_Permissions.json
  ]
  tags = var.tags
}

# Create EKS Ingress Controller IAMServiceAccount
# --------------------------------------------------------------------------
module "elb_ingress_service_account" {
  source = "../../modules/iam_role"
  application = var.application
  environment = "${var.environment}-elb-ingress-controller-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_for_alb_service_role.json
  custom_policies = [
    data.aws_iam_policy_document.elb_ingress_controller.json
  ]
  tags = var.tags
}

####################################################################################################
# Create Cloudwatch log group for EKS cluster
resource "aws_cloudwatch_log_group" "eks_log_group" {
  name              = "/aws/eks/${var.application}-${var.environment}-eks-cluster/cluster"
  retention_in_days = 7
  tags = var.tags
}

####################################################################################################
# resource "aws_security_group" "additional" {
#   name_prefix = "${var.application}-${var.environment}-eks-cluster-additional-sg"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port = 22
#     to_port   = 22
#     protocol  = "tcp"
#     cidr_blocks = [var.additional_cidrs]
#   }

#   tags = local.tags
# }

#####################################################################################################
# Create EKS Cluster
# --------------------------------------------------------------------------
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.application}-${var.environment}-eks-cluster"
  role_arn = module.eks_iam_role.arn
  enabled_cluster_log_types = ["api", "audit", "scheduler"]
  version = var.cluster_version
  tags = var.tags

  encryption_config {
      resources = [ "secrets" ]
      provider {
          key_arn = aws_kms_key.eks_kms_key.arn
      }
  }


  vpc_config {
    subnet_ids = concat(var.lb_subnet_ids,var.app_subnet_ids,var.db_subnet_ids)
    //subnet_ids = var.app_subnet_ids
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr
  }


# Wait for creating the IAM policy attachment
  depends_on = [
    module.eks_iam_role,
    aws_cloudwatch_log_group.eks_log_group
  ]
}



# Enabling IAM Roles for Service Accounts
#--------------------------------------------------------------------------------#

# Get Certificate
data "tls_certificate" "tls_cert" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

# Create IAM provider for OpenID Connect
#--------------------------------------------------------------------------------#
resource "aws_iam_openid_connect_provider" "openid_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.tls_cert.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
  tags = var.tags
}


# # IAM Assume Role for Service Account
#--------------------------------------------------------------------------------#
# resource "aws_iam_role" "aws_iam_role_assume" {
#   assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
#   name               = "${var.application}-${var.environment}-iam-assume-role"
#   tags = var.tags
# }



# # OIDC Identity Providers configuration
#--------------------------------------------------------------------------------#
# resource "aws_eks_identity_provider_config" "eks_identity_provider_config" {
#   cluster_name = aws_eks_cluster.eks_cluster.name
#   tags = var.tags

#   oidc {
#     client_id                     = aws_iam_openid_connect_provider.openid_provider.id
#     identity_provider_config_name = "${var.application}-${var.environment}-oidc-config"
#     issuer_url                    =  aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
#     groups_claim                  = var.groups_claim
#     username_claim                = var.username_claim
#   }
# }
