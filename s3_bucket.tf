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
  shared_config_files      = ["C:/Users/hashim/.aws/config"]
  shared_credentials_files = ["C:/Users/hashim/.aws/credentials"]
  profile                  = "iamadmin-general"
}

resource "aws_s3_bucket" "hr-test-bucket-2024-02-17" {
  bucket = "hr-test-bucket-2024-02-17"

  tags = {
    Name        = "My Bucket"
    Environment = "dev"
  }
}


resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.hr-test-bucket-2024-02-17.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}



resource "aws_s3_bucket_ownership_controls" "test" {
  bucket = aws_s3_bucket.hr-test-bucket-2024-02-17.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "allow_public_read" {
  bucket                  = aws_s3_bucket.hr-test-bucket-2024-02-17.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_acl" "test" {
  depends_on = [aws_s3_bucket_public_access_block.allow_public_read, aws_s3_bucket_ownership_controls.test]
  bucket     = aws_s3_bucket.hr-test-bucket-2024-02-17.id
  acl        = "public-read"
}

resource "aws_s3_object" "index" {
  key          = "index.html"
  bucket       = aws_s3_bucket.hr-test-bucket-2024-02-17.id
  source       = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  key          = "error.html"
  bucket       = aws_s3_bucket.hr-test-bucket-2024-02-17.id
  source       = "error.html"
  content_type = "text/html"

}

data "aws_iam_policy_document" "example" {
  statement {
    sid     = "1"
    actions = ["s3:*"]
    resources = [
      "${aws_s3_bucket.hr-test-bucket-2024-02-17.arn}/*",
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.hr-test-bucket-2024-02-17.id
  policy = data.aws_iam_policy_document.example.json
}
