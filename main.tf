######################################################
# DATA
######################################################
data "aws_availability_zones" "list" {}


//module "public_subnets_route_table" {
//  source = "./modules/public-subnets-route-table"
//
//  base_name = "${var.base_name}"
//  vpc_id = "${module.vpc.vpc_id}"
//  igw_id = "${module.vpc.igw_id}"
//  route_cidr_block= "${var.route_cidr_block}"
//}
//
//######################################################
//# AVAILABILITY ZONE 1 SUBNETS
//######################################################
//module "public_subnet_az1" {
//  source = "./modules/subnet"
//
//  base_name = "${var.base_name}"
//  name = "${var.base_name}-public-subnet-az1-${var.environment}"
//  vpc_id = "${module.vpc.vpc_id}"
//  cidr_block = "${var.public_subnet_az1_cidr_block}"
//  availability_zone = "${data.aws_availability_zones.list.names[0]}"
//  map_public_ip_on_launch = true
//}
//
//module "private_subnet_group_a_az1" {
//  source = "./modules/subnet"
//
//  base_name = "${var.base_name}"
//  name = "${var.base_name}-private-subnet-group-a-az1-${var.environment}"
//  vpc_id = "${module.vpc.vpc_id}"
//  cidr_block = "${var.private_subnet_az1_group_a_cidr_block}"
//  availability_zone = "${data.aws_availability_zones.list.names[0]}"
//  map_public_ip_on_launch = false
//}
//
//module "private_subnet_group_b_az1" {
//  source = "./modules/subnet"
//
//  base_name = "${var.base_name}"
//  name = "${var.base_name}-private-subnet-group-b-az1-${var.environment}"
//  vpc_id = "${module.vpc.vpc_id}"
//  cidr_block = "${var.private_subnet_az1_group_b_cidr_block}"
//  availability_zone = "${data.aws_availability_zones.list.names[0]}"
//  map_public_ip_on_launch = false
//}
//
//######################################################
//# AVAILABILITY ZONE 2 SUBNETS
//######################################################
//module "public_subnet_az2" {
//  source = "./modules/subnet"
//
//  base_name = "${var.base_name}"
//  name = "${var.base_name}-public-subnet-az2-${var.environment}"
//  vpc_id = "${module.vpc.vpc_id}"
//  cidr_block = "${var.public_subnet_az2_cidr_block}"
//  availability_zone = "${data.aws_availability_zones.list.names[1]}"
//  map_public_ip_on_launch = true
//}
//
//module "private_subnet_group_a_az2" {
//  source = "./modules/subnet"
//
//  base_name = "${var.base_name}"
//  name = "${var.base_name}-private-subnet-group-a-az2-${var.environment}"
//  vpc_id = "${module.vpc.vpc_id}"
//  cidr_block = "${var.private_subnet_az2_group_a_cidr_block}"
//  availability_zone = "${data.aws_availability_zones.list.names[1]}"
//  map_public_ip_on_launch = false
//}
//
//module "private_subnet_group_b_az2" {
//  source = "./modules/subnet"
//
//  base_name = "${var.base_name}"
//  name = "${var.base_name}-private-subnet-group-b-az2-${var.environment}"
//  vpc_id = "${module.vpc.vpc_id}"
//  cidr_block = "${var.private_subnet_az2_group_b_cidr_block}"
//  availability_zone = "${data.aws_availability_zones.list.names[1]}"
//  map_public_ip_on_launch = false
//}
//
//######################################################
//# AVAILABILITY ZONE 3 SUBNETS
//######################################################
//module "public_subnet_az3" {
//  source = "./modules/subnet"
//
//  base_name = "${var.base_name}"
//  name = "${var.base_name}-public-subnet-az3-${var.environment}"
//  vpc_id = "${module.vpc.vpc_id}"
//  cidr_block = "${var.public_subnet_az3_cidr_block}"
//  availability_zone = "${data.aws_availability_zones.list.names[2]}"
//  map_public_ip_on_launch = true
//}
//
//module "private_subnet_group_a_az3" {
//  source = "./modules/subnet"
//
//  base_name = "${var.base_name}"
//  name = "${var.base_name}-private-subnet-group-a-az3-${var.environment}"
//  vpc_id = "${module.vpc.vpc_id}"
//  cidr_block = "${var.private_subnet_az3_group_a_cidr_block}"
//  availability_zone = "${data.aws_availability_zones.list.names[2]}"
//  map_public_ip_on_launch = false
//}
//
//module "private_subnet_group_b_az3" {
//  source = "./modules/subnet"
//
//  base_name = "${var.base_name}"
//  name = "${var.base_name}-private-subnet-group-b-az3-${var.environment}"
//  vpc_id = "${module.vpc.vpc_id}"
//  cidr_block = "${var.private_subnet_az3_group_b_cidr_block}"
//  availability_zone = "${data.aws_availability_zones.list.names[2]}"
//  map_public_ip_on_launch = false
//}
//
//############################################################
//# Associate Public Subnets with Public Subnets Route Table
//############################################################
//module "public_subnet_az1_rta" {
//  source = "./modules/rte-tbl-assoc"
//
//  base_name = "${var.base_name}"
//  route_table_id = "${module.public_subnets_route_table.rt_id}"
//  subnet_id = "${module.public_subnet_az1.subnet_id}"
//}
//
//module "public_subnet_az2_rta" {
//  source = "./modules/rte-tbl-assoc"
//
//  base_name = "${var.base_name}"
//  route_table_id = "${module.public_subnets_route_table.rt_id}"
//  subnet_id = "${module.public_subnet_az2.subnet_id}"
//}
//
//module "public_subnet_az3_rta" {
//  source = "./modules/rte-tbl-assoc"
//
//  base_name = "${var.base_name}"
//  route_table_id = "${module.public_subnets_route_table.rt_id}"
//  subnet_id = "${module.public_subnet_az3.subnet_id}"
//}
//
//############################################################
//# Create and Associate NAT Gateways with Public Subnets
//############################################################
//module "ngw_az1" {
//  source = "./modules/nat-gw"
//
//  name = "${var.base_name}-ngw-az1-${var.environment}"
//  eip_id = "${module.vpc.eip_ids[0]}"
//  public_subnet_id = "${module.public_subnet_az1.subnet_id}"
//}
//
//module "ngw_az2" {
//  source = "./modules/nat-gw"
//
//  name = "${var.base_name}-ngw-az2-${var.environment}"
//  eip_id = "${module.vpc.eip_ids[1]}"
//  public_subnet_id = "${module.public_subnet_az2.subnet_id}"
//}
//
//module "ngw_az3" {
//  source = "./modules/nat-gw"
//
//  name = "${var.base_name}-ngw-az3-${var.environment}"
//  eip_id = "${module.vpc.eip_ids[2]}"
//  public_subnet_id = "${module.public_subnet_az3.subnet_id}"
//}
//
//############################################################
//# Create and Associate Route Tables for Private Subnets
//############################################################
//#-- AZ 1 --
//module "pvt_sn_grp_a_az1_rt"{
//  source = "./modules/private-subnets-route-table"
//
//  name = "${var.base_name}-pvt_sn_grp_a_az1_rt-${var.environment}"
//  vpc_id = "${module.vpc.vpc_id}"
//  route_cidr_block = "${var.route_cidr_block}"
//  ngw_id = "${module.ngw_az1.ngw_id}"
//}
//
//module "pvt_sn_grp_b_az1_rt"{
//  source = "./modules/private-subnets-route-table"
//
//  name = "${var.base_name}-pvt_sn_grp_b_az1_rt-${var.environment}"
//  vpc_id = "${module.vpc.vpc_id}"
//  route_cidr_block = "${var.route_cidr_block}"
//  ngw_id = "${module.ngw_az1.ngw_id}"
//}
//
//module "pvt_sn_grp_a_az1_rta" {
//  source = "./modules/rte-tbl-assoc"
//
//  route_table_id = "${module.pvt_sn_grp_a_az1_rt.rt_id}"
//  subnet_id = "${module.private_subnet_group_a_az1.subnet_id}"
//}
//
//module "pvt_sn_grp_b_az_rta" {
//  source = "./modules/rte-tbl-assoc"
//
//  route_table_id = "${module.pvt_sn_grp_b_az1_rt.rt_id}"
//  subnet_id = "${module.private_subnet_group_b_az1.subnet_id}"
//}
//
//#-- AZ 2 --
//module "pvt_sn_grp_a_az2_rt"{
//  source = "./modules/private-subnets-route-table"
//
//  name = "${var.base_name}-pvt_sn_grp_a_az2_rt-${var.environment}"
//  vpc_id = "${module.vpc.vpc_id}"
//  route_cidr_block = "${var.route_cidr_block}"
//  ngw_id = "${module.ngw_az2.ngw_id}"
//}
//
//module "pvt_sn_grp_b_az2_rt"{
//  source = "./modules/private-subnets-route-table"
//
//  name = "${var.base_name}-pvt_sn_grp_b_az2_rt-${var.environment}"
//  vpc_id = "${module.vpc.vpc_id}"
//  route_cidr_block = "${var.route_cidr_block}"
//  ngw_id = "${module.ngw_az2.ngw_id}"
//}
//
//module "pvt_sn_grp_a_az2_rta" {
//  source = "./modules/rte-tbl-assoc"
//
//  route_table_id = "${module.pvt_sn_grp_a_az2_rt.rt_id}"
//  subnet_id = "${module.private_subnet_group_a_az2.subnet_id}"
//}
//
//module "pvt_sn_grp_b_az2_rta" {
//  source = "./modules/rte-tbl-assoc"
//
//  route_table_id = "${module.pvt_sn_grp_b_az2_rt.rt_id}"
//  subnet_id = "${module.private_subnet_group_b_az2.subnet_id}"
//}
//
//#-- AZ 3 --
//module "pvt_sn_grp_a_az3_rt"{
//  source = "./modules/private-subnets-route-table"
//
//  name = "${var.base_name}-pvt_sn_grp_a_az3_rt-${var.environment}"
//  vpc_id = "${module.vpc.vpc_id}"
//  route_cidr_block = "${var.route_cidr_block}"
//  ngw_id = "${module.ngw_az3.ngw_id}"
//}
//
//module "pvt_sn_grp_b_az3_rt"{
//  source = "./modules/private-subnets-route-table"
//
//  name = "${var.base_name}-pvt_sn_grp_b_az3_rt-${var.environment}"
//  vpc_id = "${module.vpc.vpc_id}"
//  route_cidr_block = "${var.route_cidr_block}"
//  ngw_id = "${module.ngw_az3.ngw_id}"
//}
//
//module "pvt_sn_grp_a_az3_rta" {
//  source = "./modules/rte-tbl-assoc"
//
//  route_table_id = "${module.pvt_sn_grp_a_az3_rt.rt_id}"
//  subnet_id = "${module.private_subnet_group_a_az3.subnet_id}"
//}
//
//module "pvt_sn_grp_b_az3_rta" {
//  source = "./modules/rte-tbl-assoc"
//
//  route_table_id = "${module.pvt_sn_grp_b_az3_rt.rt_id}"
//  subnet_id = "${module.private_subnet_group_b_az3.subnet_id}"
//}

output "subnets_1" {
  value = "${cidrsubnet("192.168.0.192/26", 2, 0)}"
}

output "subnets_2" {
  value = "${cidrsubnet("192.168.0.192/26", 2, 1)}"
}

output "subnets_3" {
  value = "${cidrsubnet("192.168.0.192/26", 2, 2)}"
}

output "subnets_4" {
  value = "${cidrsubnet("192.168.0.192/26", 2, 3)}"
}
