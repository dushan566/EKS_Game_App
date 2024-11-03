# Author : Dushan Wijesinghe | 2021 #
#####################################

#
module "nodegroup_iam_role" {
  source = "../../modules/iam_role"
  application = var.application
  environment = "${var.environment}-nodegroup"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_for_eks_node_group.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  custom_policies = []
  tags = var.tags
}


########################################################################################

# # IAM Role for EKS Node Group
# resource "aws_iam_role" "nodegroup_iam_role" {
#   name = lower("${var.application}-${var.environment}-eks-nodegroup-iam-role")
#   tags            = var.tags
#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }


# resource "aws_iam_policy" "eks_node_group_iam_policy" {
#   policy = "${data.aws_iam_policy_document.ec2_NodeGroup_Permissions.json}"
# }

# # IAM Policy attachment for AmazonEKSWorkerNodePolicy
# resource "aws_iam_role_policy_attachment" "EKSNodeGroup_Policy_attachment" {
#   policy_arn = aws_iam_policy.eks_node_group_iam_policy.arn
#   role       = aws_iam_role.nodegroup_iam_role.name
# }

# # IAM Policy attachment for AmazonEKSWorkerNodePolicy
# resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNode_Policy_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.nodegroup_iam_role.name
# }
# # IAM Policy attachment for AmazonEKS_CNI_Policy
# resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.nodegroup_iam_role.name
# }
# # IAM Policy attachment for AmazonEC2ContainerRegistryReadOnly
# resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly_Policy_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.nodegroup_iam_role.name
# }

#----------------------------------------------------------------------------------------#

# Create EKS Node group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = var.aws_eks_cluster_name
  node_group_name = lower("${var.application}-${var.environment}-eks-node-group")
  # node_role_arn   = aws_iam_role.nodegroup_iam_role.arn
  node_role_arn   = module.nodegroup_iam_role.arn
  subnet_ids      = [var.subnet_ids[0], var.subnet_ids[1]]
  ami_type        = var.ami_type
  disk_size       = var.disk_size
  instance_types  = [var.instance_types]
  capacity_type  = var.capacity_type
  labels          = var.labels
  tags            = var.tags
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

# Ensure that IAM Role permissions are attached before creating node group
  # depends_on = [
  #   aws_iam_role_policy_attachment.AmazonEKSWorkerNode_Policy_attachment,
  #   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy_attachment,
  #   aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly_Policy_attachment
  # ]
}
