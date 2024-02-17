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

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allows SSH from any source IP"
  vpc_id      = "vpc-09bd74efc602cf216"
  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
}

resource "aws_instance" "app_server" {
  ami                    = "ami-0e731c8a588258d0d"
  instance_type          = "t2.micro"
  key_name               = "hr-test"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "test"
  }
}
