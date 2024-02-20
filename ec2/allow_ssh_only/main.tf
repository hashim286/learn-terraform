# creates security group for the instance
resource "aws_security_group" "allow_ssh" {
  name        = var.security_group_name
  description = "Allows SSH from any source IP"
  vpc_id      = var.vpc_id
}

# permits only SSH traffic ingress to the instance
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.ingress_port_range[0]
  to_port           = var.ingress_port_range[1]
  ip_protocol       = "tcp"
}

# permits all traffic egress from the instance
resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.egress_port_range[0]
  to_port           = var.egress_port_range[1]
  ip_protocol       = "-1"
}

# creates ec2 instance
resource "aws_instance" "ec2_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # Names the instance
  tags = {
    Name = var.instance_name
  }
}

# ssh command to run
output "ssh_cmd" {
  value       = "Make sure you are in the directory with the private key file!\nssh ec2-user@${aws_instance.ec2_server.public_ip} -m hmac-sha2-512 -i '${aws_instance.ec2_server.key_name}.pem'"
  description = "ssh command to run after instance creation"
}

# Listing public IP 
output "instance_ip_addr" {
  value       = aws_instance.ec2_server.public_ip
  description = "Public IP of server"
}
