
data "aws_caller_identity" "current" {}

# data "aws_caller_identity" "source" {
#   provider = aws.source
# }



# Assume Role Policy EKS.
# --------------------------------------------------------------------------
data "aws_iam_policy_document" "EKSAssumeRolePolicy" {
  # provider = aws.destination
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      //identifiers = ["arn:aws:iam::${data.aws_caller_identity.source.account_id}:root"]

    }
  }
}

      
# data "aws_iam_policy_document" "EKSAssumeRolePolicy" {
#   statement {
#     actions = [
#       "sts:AssumeRole"
#     ]
#     effect = "Allow"

#     principals {
#       type = "Service"
#       identifiers = [
#         "eks.amazonaws.com"
#       ]
#     }
#   }
# }

# 3 Assume Role Policy EKSAdminAssumePolicy for Groups
# --------------------------------------------------------------------------
data "aws_iam_policy_document" "EKSAdminAssumePolicy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    resources = [module.eks_admin_iam_role.arn]
  }
}


# 3 Assume Role Policy EKSDeveloperAssumePolicy for Groups
# --------------------------------------------------------------------------
data "aws_iam_policy_document" "EKSDeveloperAssumePolicy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    resources = [module.eks_developer_iam_role.arn]
  }
}


# 3 Assume Role Policy EKSReadonlyAssumePolicy for Groups
# --------------------------------------------------------------------------
data "aws_iam_policy_document" "EKSReadonlyAssumePolicy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    resources = [module.eks_readonly_iam_role.arn]
    //resources = [ "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/EKS-Readonly" ]
  }
}



# 4 EKS Admin Role Policy
# --------------------------------------------------------------------------
data "aws_iam_policy_document" "EKSAdminPolicy" {
  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]
    
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["eks.amazonaws.com"]
    }
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [ "eks:*" ]
    resources = [ "*" ]
  }
}



# 4 EKS Developer Role Policy
# --------------------------------------------------------------------------
data "aws_iam_policy_document" "EKSDeveloperPolicy" {
  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]
    
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["eks.amazonaws.com"]
    }
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
        "eks:DescribeNodegroup",
        "eks:ListNodegroups",
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:AccessKubernetesApi",
        "ssm:GetParameter",
        "eks:ListUpdates",
        "eks:ListFargateProfiles"
     ]
    resources = [ "*" ]
  }
}

# EKS ReadOnly Role Policy
# --------------------------------------------------------------------------
data "aws_iam_policy_document" "EKSReadonlyPolicy" {
  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]
    
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["eks.amazonaws.com"]
    }
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
        "eks:DescribeNodegroup",
        "eks:ListNodegroups",
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:AccessKubernetesApi",
        "ssm:GetParameter",
        "eks:ListUpdates",
        "eks:ListFargateProfiles"
     ]
    resources = [ "*" ]
  }
}