## Usage

```
module "iam_role" {
  source = "../terraform_modules/iam_role"
  application = var.application
  environment = var.environment
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_name.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSPolicy1",
    "arn:aws:iam::aws:policy/AWSPolicy2",
  ]
  custom_policies = [
    data.aws_iam_policy_document.my_cusomt_policy_name1.json,
    data.aws_iam_policy_document.my_cusomt_policy_name2.json
  ]
  tags = var.tags
}
```

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application | Name of the application | `string` | n/a | yes |
| environment | Env to which the resources belong, Indicates sybsystem or intigration name| `string` | n/a | yes |
| assume\_role\_policy | JSON string for Assume Role Policy | `string` | n/a | yes |
| managed\_policy\_arns | ARNs of managed IAM policies to be attached to the role | `set(string)` | `[]` | no |
| custom\_policies | List of JSON strings where each JSON string represent a policy | `set(string)` | `[]` | no |
| tags | A set of AWS tags | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| iam\_role\_name |iam role name |
| iam\_role\_arn | iam role arn |
