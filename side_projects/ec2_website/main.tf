# create role
resource "aws_iam_role" "allow_s3" {
  name               = "allow_s3_access"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

# role assumption policy
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# data for the role perms
data "aws_iam_policy_document" "allow_s3_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

# policy of the role created, references above data as the policy data
resource "aws_iam_role_policy" "role_policy" {
  name   = "allow_s3"
  role   = aws_iam_role.allow_s3.id
  policy = data.aws_iam_policy_document.allow_s3_policy.json
}

# creates ec2 profile based on role
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "profile_ec2"
  role = aws_iam_role.allow_s3.id
}

# makes security group in default vpc
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "allows web traffic to server"
  vpc_id      = "vpc-09bd74efc602cf216"
  tags = {
    Name = "Allow_web"
  }
}

# rule to permit all web traffic inbound, added to security group above
resource "aws_vpc_security_group_ingress_rule" "allow_ipv4_http" {
  security_group_id = aws_security_group.allow_web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

# rule to permit all ssh traffic inbound, added to same security group
resource "aws_vpc_security_group_ingress_rule" "allow_ipv4_ssh" {
  security_group_id = aws_security_group.allow_web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

# rule to allow all traffic out from the instance, added to same security group
resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4_out" {
  security_group_id = aws_security_group.allow_web.id
  ip_protocol       = "-1"
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"
}

# creates the instance and attaches the instance profile and security groups
resource "aws_instance" "web_server" {
  ami                    = "ami-0e731c8a588258d0d"
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.id
  instance_type          = "t2.micro"
  key_name               = "hr-test"
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  tags = {
    Name = "web_server"
  }

  # defines user data from the ec2.sh file to be run at launch
  user_data = file("ec2.sh")
}

# creates s3 bucket for html files
resource "aws_s3_bucket" "html_bucket" {
  bucket = "hr-bucket-123"
  tags = {
    Name = "html_bucket"
  }
}

# uploads index.html to bucket
resource "aws_s3_object" "index" { # uploads object to s3
  key          = "index.html"
  bucket       = aws_s3_bucket.html_bucket.id
  source       = "index.html"
  content_type = "text/html"
}

# uploads error.html to bucket
resource "aws_s3_object" "error" { # uploads object to s3
  key          = "error.html"
  bucket       = aws_s3_bucket.html_bucket.id
  source       = "error.html"
  content_type = "text/html"
}

# gives ssh command to be run after stack creation
output "ssh_cmd" {
  value       = "Make sure you are in the directory with the private key file!\nssh ec2-user@${aws_instance.web_server.public_ip} -m hmac-sha2-512 -i '${aws_instance.web_server.key_name}.pem'"
  description = "ssh command to run after instance creation"
}

# provides URL of instance to navigate to webpage, may have to wait a few seconds before the html displays properly
output "instance_url" {
  value       = "http://${aws_instance.web_server.public_ip}"
  description = "URL for server"
}