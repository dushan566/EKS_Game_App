resource "aws_iam_group" "iam_group" {
  for_each = var.iam_group_names
  name = each.value
  path = "/users/"
}


