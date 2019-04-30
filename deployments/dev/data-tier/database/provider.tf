# https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBClusterParameterGroup.html
# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Updates.20180206.html
# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless.html


provider "aws" {
  region = "${var.aws_region}"

  # Make it faster by skipping some checks
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

terraform {
  backend "s3" {
    bucket = "sema-terraform-state"
    region = "us-west-2"
    key = "dev/data-tier/database/terraform.state"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }
}
