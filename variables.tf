######################################################
# COMMON VARIABLES
######################################################
variable base_name {}
variable environment {
  default = "dev"
}
variable region {
  default = "us-west-2"
}

######################################################
# PROVIDER VARIABLES
######################################################
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "private_key_path" {}
variable "key_name" {
  default = "sema-us-west-2"
}

######################################################
# VPC VARIABLES
######################################################
variable network_address_space {}
variable eip_count {}

#################################
# Public Route Table Variables
#################################
variable "route_cidr_block" {
  default = "0.0.0.0/0"
}

######################################################
# Availability Zone 1 CIDR Blocks
######################################################
variable "public_subnet_az1_cidr_block" {}
variable "private_subnet_az1_group_a_cidr_block" {}
variable "private_subnet_az1_group_b_cidr_block" {}

######################################################
# Availability Zone 2 CIDR Blocks
######################################################
variable "public_subnet_az2_cidr_block" {}
variable "private_subnet_az2_group_a_cidr_block" {}
variable "private_subnet_az2_group_b_cidr_block" {}

######################################################
# Availability Zone 3 CIDR Blocks
######################################################
variable "public_subnet_az3_cidr_block" {}
variable "private_subnet_az3_group_a_cidr_block" {}
variable "private_subnet_az3_group_b_cidr_block" {}

