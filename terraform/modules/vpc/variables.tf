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

variable "availability_zones" {
  type = list
  default = [
    "eu-west-1a"]
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
    db = [
      "20.5.0.0/24"]
    app = [
      "20.5.2.0/24"]
    lb = [
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
