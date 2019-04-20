##################################################
# Provider Variable
##################################################
variable "aws_region" {
  default = "us-west-2"
}

##################################################
# VPC Variable
##################################################
variable "namespace" {}
variable "stage" {}
variable "name" {}
variable "cidr_block" {}

variable "max_subnets" {}
variable "availability_zones" {
  type = "list"
}
