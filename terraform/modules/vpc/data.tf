# Availability Zones.
data "aws_availability_zones" "all_azs" {
  state = "available"
}

