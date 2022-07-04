terraform {
  required_version = ">=0.12.13"
  backend "s3" {
    bucket         = "local-terrafm-state-mgmt-bucket-bar"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "local_tf_s3_lock_state_name"
    encrypt        = true
  }
}

provider "aws" {
  region  = "us-east-1"
  version = "4.0.0"
}


module "bootstrap" {
  source                      = "./modules/bootstrap"
  name_of_s3_bucket           = "avalon-glory-terrafm-state-mgmt-bucket-bar"
  dynamo_db_table_name        = "avalon-glory_tf_s3_lock_state_name"
}