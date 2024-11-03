#################################### Basic VPC Outputs ##############################
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "app_subnet_ids" {
  value = module.vpc.app_subnet_ids
}

output "lb_subnet_ids" {
  value = module.vpc.lb_subnet_ids
}

output "db_subnet_ids" {
  value = module.vpc.db_subnet_ids
}

output "public_route_table_id" {
  value = module.vpc.public_route_table_id
}

output "private_route_table_id" {
  value = module.vpc.private_route_table_id
}


#################################### EKS Cluster Outputs ##############################
output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "eks_iam_role_name" {
    value = module.eks_cluster.eks_iam_role_name
}

output "eks_iam_role_arn" {
    value = module.eks_cluster.eks_iam_role_arn
}


output "node_iam_role_arn" {
    value = module.eks_cluster_node_group.node_iam_role_arn
}

output "elb_ingress_controller_service_account_role_name" {
    value = module.eks_cluster.elb_ingress_controller_service_account_role_name
}

output "elb_ingress_controller_service_account_role_arn" {
    value = module.eks_cluster.elb_ingress_controller_service_account_role_arn
}


output "kubeconfig_certificate_authority_data" {
  value = module.eks_cluster.kubeconfig_certificate_authority_data
}

output "identity-oidc-issuer" {
  value = module.eks_cluster.identity-oidc-issuer
}

#output "kubeconfig-certificate-authority-data" {
#  value = module.eks_cluster.kubeconfig-certificate-authority-data
#}


output "eks_admin_iam_role_arn" {
    value = module.eks_users.eks_admin_iam_role_arn
}

output "eks_developer_iam_role_arn" {
    value = module.eks_users.eks_developer_iam_role_arn
}

output "eks_readonly_iam_role_arn" {
    value = module.eks_users.eks_readonly_iam_role_arn
}