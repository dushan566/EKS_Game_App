# --------------------------------------------------------------------------
# Assume Role Policy EKS Node Group.

data "aws_iam_policy_document" "assume_role_policy_for_eks_node_group" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}


# --------------------------------------------------------------------------
# EC2 Node group permissions

data "aws_iam_policy_document" "Cloudwatch_Put_Metrics" {
  statement {
    actions = [
      "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
    effect = "Allow"
  }
}
# --------------------------------------------------------------------------


# --------------------------------------------------------------------------
# Policy for EC2 Node groups

data "aws_iam_policy_document" "ec2_NodeGroup_Permissions" {
  statement {
    actions = [
      "ec2:RevokeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:DescribeInstances",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:DeleteSecurityGroup"
    ]
    resources = ["*"]
    effect = "Allow"
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/eks"
      values   = ["*"]
    }
  }

  statement {
    actions = [
      "ec2:RevokeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:DescribeInstances",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:DeleteSecurityGroup"
    ]
    resources = ["*"]
    effect = "Allow"
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/eks:nodegroup-name"
      values   = ["*"]
    }
  }

  statement {
    actions = [
      "ec2:DeleteLaunchTemplate",
      "ec2:CreateLaunchTemplateVersion"
    ]
    resources = ["*"]
    effect = "Allow"
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/eks:nodegroup-name"
      values   = ["*"]
    }
  }

  statement {
    actions = [
      "autoscaling:UpdateAutoScalingGroup",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:CompleteLifecycleAction",
      "autoscaling:PutLifecycleHook",
      "autoscaling:PutNotificationConfiguration",
      "autoscaling:EnableMetricsCollection"
    ]
    resources = ["arn:aws:autoscaling:*:*:*:autoScalingGroupName/eks-*"]
    effect = "Allow"
  }

  statement {
    actions = [
      "iam:CreateServiceLinkedRole"
    ]
    resources = ["*"]
    effect = "Allow"
    condition {
      test     = "StringEquals"
      variable = "iam:AWSServiceName"
      values   = ["autoscaling.amazonaws.com"]
    }
  }

  statement {
    actions = [
      "autoscaling:CreateOrUpdateTags",
      "autoscaling:CreateAutoScalingGroup"
    ]
    resources = ["*"]
    effect = "Allow"
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:TagKeys"
      values   = ["eks", "eks:cluster-name", "eks:nodegroup-name"]
    }
  }

  statement {
    actions = [
      "iam:PassRole"
    ]
    resources = ["*"]
    effect = "Allow"
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["autoscaling.amazonaws.com"]
    }
  }

  statement {
    actions = [
      "iam:PassRole"
    ]
    resources = ["*"]
    effect = "Allow"
    condition {
      test     = "StringEqualsIfExists"
      variable = "iam:PassedToService"
      values   = ["ec2.amazonaws.com", "ec2.amazonaws.com.cn"]
    }
  }

  statement {
    actions = [
      "iam:GetRole",
      "ec2:CreateLaunchTemplate",
      "ec2:DescribeInstances",
      "iam:GetInstanceProfile",
      "ec2:DescribeLaunchTemplates",
      "autoscaling:DescribeAutoScalingGroups",
      "ec2:CreateSecurityGroup",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:RunInstances",
      "ec2:DescribeSecurityGroups",
      "ec2:GetConsoleOutput",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSubnets"
    ]
    resources = ["*"]
    effect = "Allow"
  }

  statement {
    actions = [
      "iam:CreateInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:AddRoleToInstanceProfile"
    ]
    resources = ["arn:aws:iam::*:instance-profile/eks-*"]
    effect = "Allow"
  }

  statement {
    actions = [
      "ec2:CreateTags",
      "ec2:DeleteTags"
    ]
    resources = ["*"]
    effect = "Allow"
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:TagKeys"
      values   = ["eks", "eks:cluster-name", "eks:nodegroup-name", "kubernetes.io/cluster/*"]
    }
  }
}
# --------------------------------------------------------------------------
