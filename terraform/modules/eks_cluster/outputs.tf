output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "kubeconfig_certificate_authority_data" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "eks_iam_role_name" {
    value = module.eks_iam_role.name
}

output "eks_iam_role_arn" {
    value = module.eks_iam_role.arn
}

output "elb_ingress_controller_service_account_role_name" {
    value = module.elb_ingress_service_account.name
}

output "elb_ingress_controller_service_account_role_arn" {
    value = module.elb_ingress_service_account.arn
}

output "identity-oidc-issuer" {
  value = replace("aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer", "https://", "")
}