variable "application" {}

variable "environment" {}

# When a policy is defined as a data object in the caller, we can get the json value of it as follows.
# data.aws_iam_policy_document.my_cusomt_policy.json
# This variable basically accepts a bunch of strings given by above command.
#
# Ex:
#   custom_policies = [
#                       data.aws_iam_policy_document.my_cusomt_policy.json,
#                       data.aws_iam_policy_document.my_cusomt_policy_2.json,
#                       data.aws_iam_policy_document.another_my_cusomt_policy.json,
#                     ]
#
variable "custom_policies" {
  type = set(string)
  default = []
  description = "List of JSON strings where each JSON string represent a policy"
}

# Same logic as 'custom_policies', but this only accepts a single string since we only have one assume policy,
# per role.
variable "assume_role_policy" {
  type = string
  description = "JSON string for Assume Role Policy"
}

variable "managed_policy_arns" {
  type = set(string)
  default = []
  description = "ARNs of managed IAM policies to be attached to the role"
}


variable "tags" {
  type = map(string)
  description = "A set of AWS tags"
}


