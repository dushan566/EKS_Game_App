# VAriable for your application name
variable "application" {
  type = string
  default = "myapp"
  description = "Name of the application"
}

variable "capacity_type" {
  default = "SPOT"
}
# Variable for your environment (demo,dev,qa, stg, perf, prd)
variable "environment" {
  type = string
  default = "dev"
  description = "Environment to which the resources belong"
}

# Variable for Subnet ID list to retrive from network state file
variable "subnet_ids" {
  type = list
  default = []
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
   
# Variable for Map of all kubernetes labels
variable "labels" {
  type = map
  default = {}
}

# Variable for Map of all common tags
variable "tags" {
  type = map
  default = {}
}
