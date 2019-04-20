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
