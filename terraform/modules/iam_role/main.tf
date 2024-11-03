# IAM Role.
resource "aws_iam_role" "iam_role" {
  name = lower("${var.application}-${var.environment}-iam-role")
  assume_role_policy = var.assume_role_policy

  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}

# Attach provided managed policies to the role.
resource "aws_iam_role_policy_attachment" "managed_policy_attachments" {
  for_each = var.managed_policy_arns
  role = aws_iam_role.iam_role.name
  policy_arn = each.value
}

# Create custom inline policies.
resource "aws_iam_role_policy" "custom_iam_policy" {
  for_each = toset(var.custom_policies)
  name = lower("${var.application}-${var.environment}-${md5(each.value)}")
  policy = each.value
  role = aws_iam_role.iam_role.id
}
