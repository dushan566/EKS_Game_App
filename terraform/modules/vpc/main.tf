/*
 * Creates the crucial network resources such as,
 *    VPC
 *    Subnets
 * Each VPC should have following subnets,
 *    DB Subnet  ->  Private subnet.
 *    App Subnet  ->  Private subnet w/ NAT.
 *    Load Balancer Subnet  ->  Public subnet w/ IGW.
 *
 * The subnets should be spread across 3 AZs in Ireland(eu-west-1)
 * Based on the number of CIDRs provided,
 */

# Let AZs be shuffled when more than 1 AZ is needed.
resource "random_shuffle" "az" {
  input = var.availability_zones
  result_count = length(var.availability_zones)
}

# VPC.
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.tags, tomap({Name = lower("${var.application}-${var.environment}-vpc")}))
}


# DB Subnet.
resource "aws_subnet" "db_subnet" {
  count = length(var.subnet_cidr_blocks.db)
  availability_zone = random_shuffle.az.result[count.index % length( random_shuffle.az.result)]
  cidr_block = var.subnet_cidr_blocks.db[count.index]
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  tags = merge(var.tags, tomap({Name = lower("${var.application}-${var.environment}-db-private-${count.index+1}")}))
}

# App Subnet  w/ NAT Gateway.
resource "aws_subnet" "app_subnet" {
  count = length(var.subnet_cidr_blocks.app)
  availability_zone = random_shuffle.az.result[count.index % length( random_shuffle.az.result)]
  cidr_block = var.subnet_cidr_blocks.app[count.index]
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  tags = merge(
        var.tags, tomap({Name = lower("${var.application}-${var.environment}-app-private-${count.index+1}")}),
        tomap({"kubernetes.io/role/internal-elb" = "1"}),
        # tomap({"eksctl.cluster.k8s.io/v1alpha1/cluster-name" = "${var.application}-${var.environment}-eks-cluster"}),
        # tomap({"alpha.eksctl.io/cluster-name" = "${var.application}-${var.environment}-eks-cluster"}),
        tomap({"kubernetes.io/cluster/${var.application}-${var.environment}-eks-cluster" = "shared"})
        )
}

# Load Balancer Subnet w/ IGW.
resource "aws_subnet" "lb_subnet" {
  count = length(var.subnet_cidr_blocks.lb)
  availability_zone = random_shuffle.az.result[count.index % length( random_shuffle.az.result)]
  cidr_block = var.subnet_cidr_blocks.lb[count.index]
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  tags = merge(
        var.tags, tomap({Name = lower("${var.application}-${var.environment}-elb-public-${count.index+1}")}),
        tomap({"kubernetes.io/role/elb" = "1"}),
        # tomap({"eksctl.cluster.k8s.io/v1alpha1/cluster-name" = "${var.application}-${var.environment}-eks-cluster"}),
        # tomap({"alpha.eksctl.io/cluster-name" = "${var.application}-${var.environment}-eks-cluster"}),
         tomap({"kubernetes.io/cluster/${var.application}-${var.environment}-eks-cluster" = "shared"})
        )
}


# NAT Gatway w/ EIP.
resource "aws_eip" "nat_eip" {
  vpc = true
  tags = merge(var.tags, tomap({Name = lower("${var.application}-${var.environment}-nat-eip")}))
}
# Create NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.lb_subnet[0].id
  tags = merge(var.tags, tomap({ Name = lower("${var.application}-${var.environment}-nat")}))
}

# IGW w/ EIP.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, tomap({ Name = lower("${var.application}-${var.environment}-igw")}))
}

# Create Public Route Table.
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, tomap({ Name = lower("${var.application}-${var.environment}-public-route-table")}))
}

# Private Route Table.
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, tomap({Name = lower("${var.application}-${var.environment}-private-route-table")}))
}

# Allow public access via Internet Gayeway
resource "aws_route" "route_to_internet" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

# Allow public outbound traffic via Internet Gayeway
resource "aws_route" "route_to_nat" {
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}


# Add routing associations to public subnets..
resource "aws_route_table_association" "association_for_route_to_igw" {
  count = length(aws_subnet.lb_subnet)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.lb_subnet[count.index].id
}

# Add routing associations to Private APP subnets..
resource "aws_route_table_association" "association_for_route_to_nat" {
  count = length(aws_subnet.app_subnet)
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.app_subnet[count.index].id
}

# Add routing associations to Private DB subnets..
resource "aws_route_table_association" "association_for_route_to_db" {
  count = length(aws_subnet.db_subnet)
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.db_subnet[count.index].id
}

# Set a name to default route table.
resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  tags = merge(var.tags, tomap({ Name = lower("${var.application}-${var.environment}-default-route-table")}))
}
