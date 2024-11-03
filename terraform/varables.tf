variable "application" {
  type = string
  default = "myapp"
  description = "Name of the application"
}

variable "environment" {
  type = string
  default = "dev"
  description = "Environment to which the resources belong"
}

variable "region" {
  type = string
  description = "aws region"
}

variable "availability_zones" {
  type = list
  default = [
    "eu-west-2a"]
  description = "Availability zones that the subnets should be distributed across"
}

variable "vpc_cidr_block" {
  type = string
  default = "20.5.0.0/16"
  description = "CIDR block for the VPC"
}

variable "subnet_cidr_blocks" {
  type = map
  default = {
    lb = [
      "20.5.0.0/24"]
    app = [
      "20.5.2.0/24"]
    db = [
      "20.5.4.0/24"]
  }
  description = "CIDR block for the subnet"
}

variable "private_routes_to_nat" {
  type = list
  default = []
  description = "IPs that should be included in the private route table that are needed to be routed to the NAT gateway."
}

variable "tags" {
  type = map
  default = {}
}


######################################## EKS Cluster Variables ############################################
variable "cluster_version" {}

variable "eks-kms-key-deletion-window" {}

variable "capacity_type" {}

variable "service_ipv4_cidr" {
  type = string
  default = "172.16.2.0/25"
  description = "EKS service endpoint IP range"
}

# Variable for EKS Cluster Name
variable "aws_eks_cluster_name" {
  type = string
  default = "mycluster"
  description = "EKS cluster name"
}

# Variable for EKS node group AMI type
variable "ami_type" {
  type = string
  default = "AL2_x86_64"
  description = "Amazon Machine Image (AMI) associated with the EKS Node Group"
}

# Variable for EKS node group disk size
variable "disk_size" {
  type = string
  default = "100"
  description = "disk_size of EKS Node Group"
}

# Variable for EKS node group disk size
variable "instance_types" {
  type = string
  default = "t3.medium"
  description = "Ec2 class of EKS Node Group"
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

variable "labels" {}