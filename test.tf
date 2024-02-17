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
  access_key = "key_id"
  secret_key = "key_value"

}

resource "aws_instance" "app_server" {
  ami           = "ami"
  instance_type = "t2.micro"
  key_name      = "key_name"
  tags = {
    Name = "test"
  }
}
