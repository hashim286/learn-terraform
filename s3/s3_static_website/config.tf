terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

terraform {
  cloud {
    organization = "hr-home"

    workspaces {
      name = "learn-tfc-aws"
    }
  }
}


provider "aws" {
  shared_config_files      = ["C:/Users/hashim/.aws/config"]
  shared_credentials_files = ["C:/Users/hashim/.aws/credentials"]
  profile                  = "iamadmin-general"
}