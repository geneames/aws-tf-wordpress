##########################################
# VPC Outputs
##########################################
output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "igw_id" {
  value = "${module.vpc.igw_id}"
}

output "vpc_cidr_block" {
  value = "${module.vpc.vpc_cidr_block}"
}

output "vpc_default_network_acl_id" {
  value = "${module.vpc.vpc_default_network_acl_id}"
}

output "vpc_main_route_table_id" {
  value = "${module.vpc.vpc_main_route_table_id}"
}

output "vpc_default_route_table_id" {
  value = "${module.vpc.vpc_default_route_table_id}"
}

output "vpc_ipv6_association_id" {
  value = "${module.vpc.vpc_ipv6_association_id}"
}

output "ipv6_cidr_block" {
  value = "${module.vpc.ipv6_cidr_block}"
}

##########################################
# Public Subnets Outputs
##########################################
output "public_az_subnet_ids" {
  value       = "${module.public_subnets.az_subnet_ids}"
  description = "Map of AZ names to subnet IDs"
}

output "public_az_route_table_ids" {
  value       = "${module.public_subnets.az_route_table_ids}"
  description = " Map of AZ names to Route Table IDs"
}

output "public_az_ngw_ids" {
  value       = "${module.public_subnets.az_ngw_ids}"
  description = "Map of AZ names to NAT Gateway IDs (only for public subnets)"
}

output "public_az_subnet_arns" {
  value       = "${module.public_subnets.az_subnet_arns}"
  description = "Map of AZ names to subnet ARNs"
}

##########################################
# Private Subnets Outputs
##########################################
output "private_az_subnet_ids" {
  value       = "${module.private_subnets.az_subnet_ids}"
  description = "Map of AZ names to subnet IDs"
}

output "private_az_route_table_ids" {
  value       = "${module.private_subnets.az_route_table_ids}"
  description = " Map of AZ names to Route Table IDs"
}

output "private_az_ngw_ids" {
  value       = "${module.private_subnets.az_ngw_ids}"
  description = "Map of AZ names to NAT Gateway IDs (only for public subnets)"
}

output "private_az_subnet_arns" {
  value       = "${module.private_subnets.az_subnet_arns}"
  description = "Map of AZ names to subnet ARNs"
}
