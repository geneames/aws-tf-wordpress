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
# RDS Cluster Variables
##################################################
//variable "zone_id" {
//  type        = "string"
//  default     = ""
//  description = "Route53 parent zone ID. If provided (not empty), the module will create sub-domain DNS records for the DB master and replicas"
//}

variable "security_groups" {
  type        = "list"
  default     = []
  description = "List of security groups to be allowed to connect to the DB instance"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID to create the cluster in (e.g. `vpc-a22222ee`)"
}

variable "subnets" {
  type        = "list"
  description = "List of VPC subnet IDs"
}

variable availability_zones {
  type        = "list"
  default     = []
  description = "The availability zones to deploy the RDS cluster into"
}

variable "cluster_size" {
  type        = "string"
  default     = "2"
  description = "Number of DB instances to create in the cluster"
}

variable "db_name" {
  type        = "string"
  description = "Database name"
}

variable "db_port" {
  type        = "string"
  default     = "3306"
  description = "Database port"
}

variable "admin_user" {
  type        = "string"
  default     = "admin"
  description = "(Required unless a snapshot_identifier is provided) Username for the master DB user"
}

variable "admin_password" {
  type        = "string"
  default     = ""
  description = "(Required unless a snapshot_identifier is provided) Password for the master DB user"
}

variable "cluster_family" {
  type        = "string"
  default     = "aurora5.6"
  description = "The family of the DB cluster parameter group"
}

variable "engine" {
  type        = "string"
  default     = "aurora"
  description = "The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql`"
}

variable "engine_mode" {
  type        = "string"
  default     = "provisioned"
  description = "The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless`"
}

##################################
# Scaling Configuration Variables
##################################
variable "scaling_configuration" {
  type        = "list"
  default     = []
  description = "List of nested attributes with scaling properties. Only valid when engine_mode is set to `serverless`"
}

# Valid values are powers of 2, up to 256. (i.e. 1, 2, 4, 8, ...)
variable "max_capacity" {
  type = "string"
  description = "Aurora Serverless can increase capacity up to this capacity unit."
}

# Valid values are powers of 2, up to 256. (i.e. 1, 2, 4, 8, ...)
variable "min_capacity" {
  type = "string"
  description = "Aurora Serverless can reduce capacity down to this capacity unit."
}

variable "auto_pause" {
  type = "string"
  default = "true"
  description = "Pause, or scale back capacity to 0 due to inactivity"
}

variable "seconds_until_auto_pause" {
  type = "string"
  description = "The amount of time with no database traffic to scale to zero processing capacity."
}
