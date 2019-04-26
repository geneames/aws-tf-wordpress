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
variable "ssh_user" {
  type        = "string"
  default = "ec2-user" // For Amazon Linux
  description = "Default SSH user for this AMI. e.g. `ec2user` for Amazon Linux and `ubuntu` for Ubuntu systems"
}

variable "welcome_message" {
  type        = "string"
  default = "Sema Bastion"
  description = "Bastion banner"
}

variable "user_data_file" {
  type        = "string"
  default     = "user_data.sh"
  description = "User data file"
}

variable "user_data" {
  type        = "list"
  default     = []
  description = "User data content"
}

variable "zone_id" {
  type        = "string"
  default     = ""
  description = "Route53 DNS Zone ID"
}

variable availability_zones {
  type        = "list"
  description = "The availability zones to deploy the bastion servers into"
}
