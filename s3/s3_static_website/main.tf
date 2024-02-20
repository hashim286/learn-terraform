


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
  depends_on = [aws_s3_bucket_public_access_block.allow_public_read, aws_s3_bucket_website_configuration.static_website] 
}

resource "aws_s3_bucket" "hr-test-bucket-2024-02-17" { # creates the bucket
  bucket = var.bucket_name
}

resource "aws_s3_bucket_website_configuration" "static_website" { # defines static website config details
  bucket = aws_s3_bucket.hr-test-bucket-2024-02-17.id
  index_document {
    suffix = var.index_file
  }

  error_document {
    key = var.error_file
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
  key          = var.index_file
  bucket       = aws_s3_bucket.hr-test-bucket-2024-02-17.id
  source       = var.index_file
  content_type = "text/html"
}

resource "aws_s3_object" "error" { # uploads object to s3
  key          = var.error_file
  bucket       = aws_s3_bucket.hr-test-bucket-2024-02-17.id
  source       = var.error_file
  content_type = "text/html"
}

output "s3_url" {
  value = "http://${aws_s3_bucket_website_configuration.static_website.website_endpoint}"
}