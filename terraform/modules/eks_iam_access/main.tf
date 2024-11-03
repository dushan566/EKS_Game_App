# 1 Create IAM Groups
# --------------------------------------------------------------------------
module "iam_groups" {
  source = "../../modules/iam_groups"
  iam_group_names = ["EKS-Admin", "EKS-Developer", "EKS-Readonly" ]
}

# 2 Create Assume role policies to be attached to step 1 IAM goups
# --------------------------------------------------------------------------
resource "aws_iam_policy" "eks_admin_assume_policy" {
  name        = "EKSAdminAssumePolicy"
  path        = "/"
  description = "EKS admin assume policy"
  policy      = data.aws_iam_policy_document.EKSAdminAssumePolicy.json
}

resource "aws_iam_policy" "eks_developer_assume_policy" {
  name        = "EKSDeveloperAssumePolicy"
  path        = "/"
  description = "EKS Developer assume policy"
  policy      = data.aws_iam_policy_document.EKSDeveloperAssumePolicy.json
}

resource "aws_iam_policy" "eks_readonly_assume_policy" {
  name        = "EKSReadonlyAssumePolicy"
  path        = "/"
  description = "EKS Readonly assume policy"
  policy      = data.aws_iam_policy_document.EKSReadonlyAssumePolicy.json
}

# 3 Attach Assume Role policies to IAM Groups instead of users
# --------------------------------------------------------------------------
resource "aws_iam_policy_attachment" "eks_admin" {
  name       = "EKS-Admin-attachment"
  groups     = ["EKS-Admin"]
  policy_arn = aws_iam_policy.eks_admin_assume_policy.arn
}

resource "aws_iam_policy_attachment" "eks_developer" {
  name       = "EKS-Developer-attachment"
  groups     = ["EKS-Developer"]
  policy_arn = aws_iam_policy.eks_developer_assume_policy.arn
}

resource "aws_iam_policy_attachment" "eks_readonly" {
  name       = "EKS-Readonly-attachment"
  groups     = ["EKS-Readonly"]
  policy_arn = aws_iam_policy.eks_readonly_assume_policy.arn
}


# 4 Create EKS-Admin IAM Role
# --------------------------------------------------------------------------
module "eks_admin_iam_role" {
  source = "../../modules/iam_role"
  application = var.application
  environment = "${var.environment}-eks-admin"
  assume_role_policy = data.aws_iam_policy_document.EKSAssumeRolePolicy.json
  managed_policy_arns = []
  custom_policies = [
    data.aws_iam_policy_document.EKSAdminPolicy.json
  ]
  tags = var.tags
}


# 4 Create EKS-Developer IAM Role
# --------------------------------------------------------------------------
module "eks_developer_iam_role" {
  source = "../../modules/iam_role"
  application = var.application
  environment = "${var.environment}-eks-developer"
  assume_role_policy = data.aws_iam_policy_document.EKSAssumeRolePolicy.json
  managed_policy_arns = []
  custom_policies = [
    data.aws_iam_policy_document.EKSDeveloperPolicy.json,
  ]
  tags = var.tags
}


# 4 Create EKS-ReadOnly IAM Role
# --------------------------------------------------------------------------
module "eks_readonly_iam_role" {
  source = "../../modules/iam_role"
  application = var.application
  environment = "${var.environment}-eks-readonly"
  assume_role_policy = data.aws_iam_policy_document.EKSAssumeRolePolicy.json
  managed_policy_arns = []
  custom_policies = [
    data.aws_iam_policy_document.EKSReadonlyPolicy.json,
  ]
  tags = var.tags
}


