output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "app_subnet_ids" {
  value = aws_subnet.app_subnet[*].id
}

output "lb_subnet_ids" {
  value = aws_subnet.lb_subnet[*].id
}

output "db_subnet_ids" {
  value = aws_subnet.db_subnet[*].id
}

output "public_route_table_id" {
  value = aws_route_table.public_route_table.id
}

output "private_route_table_id" {
  value = aws_route_table.private_route_table.id
}