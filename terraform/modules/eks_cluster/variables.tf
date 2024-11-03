# VAriable for your application name
variable "application" {
  type = string
  default = "myapp"
  description = "Name of the application"
}

#variable "account-id" {}

variable "cluster_version" {}

variable "eks-kms-key-deletion-window" {}

# Variable for your environment (demo,dev,qa, stg, perf, prd)
variable "environment" {
  type = string
  default = "dev"
  description = "Environment to which the resources belong"
}

# Variable for EKS Service IP range
variable "service_ipv4_cidr" {
  type = string
  default = "172.16.2.0/25"
  description = "EKS service endpoint IP range"
}

# Variable for get lb subnets from Network state file
variable "lb_subnet_ids" {
  type = list
  default = []
}

# Variable for get app subnets from Network state file
variable "app_subnet_ids" {
  type = list
  default = []
}

# Variable for get db subnets from Network state file
variable "db_subnet_ids" {
  type = list
  default = []
}

# Variable for EKS OIDC config group claim
variable "groups_claim" {
  type = string
  default = "system:masters"
  description = "EKS OIDC config group claim"
}

# Variable for EKS OIDC config user claim
variable "username_claim" {
  type = string
  default = "role/PowerUser"
  description = "EKS OIDC config user claim"
}

# Variable for Map of all common tags
variable "tags" {
  type = map
  default = {}
}
