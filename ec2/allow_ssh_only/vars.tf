variable "security_group_name" {
  type        = string
  description = "Name for the security group"
}

variable "ingress_port_range" {
  type = list(number)
}

variable "egress_port_range" {
  type = list(number)
}

variable "ami_id" {
  type    = string
  default = "ami-0e731c8a588258d0d"
}

variable "ssh_key_name" {
  type    = string
  default = "hr-test"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_name" {
  type = string
}

variable "vpc_id" {
  type    = string
  default = "vpc-09bd74efc602cf216"
}


