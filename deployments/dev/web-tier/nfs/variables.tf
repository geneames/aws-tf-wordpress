##################################################
# Provider & Tags Variables
##################################################
variable "aws_region" {
  default = "us-west-2"
}

variable "namespace" {
  type        = "string"
  description = "Namespace, which could be your organization name, e.g. 'eg' or 'cp'"
}

variable "stage" {
  type        = "string"
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
}

variable "environment" {
  type        = "string"
  default     = ""
  description = "Environment, e.g. 'testing', 'UAT'"
}

variable "name" {
  type        = "string"
  default     = "app"
  description = "Solution name, e.g. 'app' or 'cluster'"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "enabled" {
  type        = "string"
  description = "Whether to create the resources. Set to `false` to prevent the module from creating any resources"
  default     = "true"
}


##################################################
# EFS Variables
##################################################
variable availability_zones {
  type        = "list"
  default     = []
  description = "The availability zones to deploy the RDS cluster into"
}

variable nfs_port {
  type        = "string"
  default     = "2049"
  description = "TCP port for NFS"
}
