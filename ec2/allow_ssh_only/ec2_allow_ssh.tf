# creates security group for the instance
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allows SSH from any source IP"
  vpc_id      = "vpc-09bd74efc602cf216"
  tags = {
    Name = "allow_ssh"
  }
}

# permits only SSH traffic ingress to the instance
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# permits all traffic egress from the instance
resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
}

# creates ec2 instance
resource "aws_instance" "ec2_server" {
  ami                    = "ami-0e731c8a588258d0d"
  instance_type          = "t2.micro"
  key_name               = "hr-test"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  
  # Names the instance
  tags = { 
    Name = "test"
  }
}

# ssh command to run
output "ssh_cmd" {
  value       = "Make sure you are in the directory with the private key file!\nssh ec2-user@${aws_instance.ec2_server.public_ip} -m hmac-sha2-512 -i '${aws_instance.ec2_server.key_name}.pem'"
  description = "Public IP of server"
}

# Listing public IP 
output "instance_ip_addr" {
  value = aws_instance.ec2_server.public_ip
}
