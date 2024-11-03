output "eks_admin_iam_role_arn" {
    value = module.eks_admin_iam_role.arn
}

output "eks_developer_iam_role_arn" {
    value = module.eks_developer_iam_role.arn
}

output "eks_readonly_iam_role_arn" {
    value = module.eks_readonly_iam_role.arn
}