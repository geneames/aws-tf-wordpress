provider "aws" {
  region = "us-west-2"
}

//terraform {
//  backend "s3" {
//    bucket = "sema-terraform-state"
//    region = "us-west-2"
//    key = "dev/terraform.state"
//    dynamodb_table = "terraform-state-locking"
//    encrypt = true
//  }
//}

terraform {
  backend "local" {
    path = "state/terraform.tfstate"
  }
}