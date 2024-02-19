terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["C:/Users/hrauf/.aws/config"]
  shared_credentials_files = ["C:/Users/hrauf/.aws/credentials"]
  profile                  = "iamadmin-general"
}