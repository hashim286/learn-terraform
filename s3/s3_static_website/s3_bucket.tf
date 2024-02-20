data "aws_iam_policy_document" "example" { # define IAM policy to permit public read
  statement {
    sid     = "PublicReadGetObject"
    actions = ["s3:GetObject"]
    resources = [
      "${aws_s3_bucket.hr-test-bucket-2024-02-17.arn}/*",
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "example" { # attaching policy made above to bucket, use depends on to tell terraform that this requires public access to be granted before this can be attached to bucket
  bucket     = aws_s3_bucket.hr-test-bucket-2024-02-17.id
  policy     = data.aws_iam_policy_document.example.json
  depends_on = [aws_s3_bucket_public_access_block.allow_public_read]
}

resource "aws_s3_bucket" "hr-test-bucket-2024-02-17" { # creates the bucket
  bucket = "hr-bucket-123"

  tags = {
    Name        = "My Bucket"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_website_configuration" "static_website" { # defines static website config details
  bucket = aws_s3_bucket.hr-test-bucket-2024-02-17.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "allow_public_read" { # turns public access on, stops AWS from blocking public policies
  bucket                  = aws_s3_bucket.hr-test-bucket-2024-02-17.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "index" { # uploads object to s3
  key          = "index.html"
  bucket       = aws_s3_bucket.hr-test-bucket-2024-02-17.id
  source       = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" { # uploads object to s3
  key          = "error.html"
  bucket       = aws_s3_bucket.hr-test-bucket-2024-02-17.id
  source       = "error.html"
  content_type = "text/html"
}

output "s3_url" {
  value = "http://${aws_s3_bucket_website_configuration.static_website.website_endpoint}"
}