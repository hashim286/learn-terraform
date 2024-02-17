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
  region     = "us-east-1"
  access_key = "AKIA6ODU6J6EGAM63QPG"
  secret_key = "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"

}

resource "aws_instance" "app_server" {
  ami           = "ami-0e731c8a588258d0d"
  instance_type = "t2.micro"
  key_name      = "hr-test"
  tags = {
    Name = "test"
  }
}