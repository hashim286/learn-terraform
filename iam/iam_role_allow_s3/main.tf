resource "aws_iam_role" "allow_s3" {
  name               = "allow_s3_access"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

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


data "aws_iam_policy_document" "allow_s3_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}


resource "aws_iam_role_policy" "role_policy" {
  name   = "allow_s3"
  role   = aws_iam_role.allow_s3.id
  policy = data.aws_iam_policy_document.allow_s3_policy.json
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "profile_ec2"
  role = aws_iam_role.allow_s3.id
}