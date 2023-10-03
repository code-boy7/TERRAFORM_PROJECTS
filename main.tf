#create s3 bucket
resource "aws_s3_bucket" "project_buckets" {
  bucket = var.s3_buck 
  
}

resource "aws_s3_bucket_ownership_controls" "s3_owner" {
  bucket = aws_s3_bucket.project_buckets.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_public_access_block" "s3_public_block" {
  bucket = aws_s3_bucket.project_buckets.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3_public_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.s3_owner,
    aws_s3_bucket_public_access_block.s3_public_block,
  ]

  bucket = aws_s3_bucket.project_buckets.id
  acl    = "public-read"
}

resource "aws_s3_object" "s3_index" {

    bucket = aws_s3_bucket.project_buckets.id
    key = "index.html"
    source = "index.html"
    acl = "public-read"
    content_type  = "text/html"
  
}

resource "aws_s3_object" "s3_error" {

    bucket = aws_s3_bucket.project_buckets.id
    key = "error.html"
    source = "error.html"
    acl = "public-read"
    content_type  = "text/html"
  
}

resource "aws_s3_object" "s3_image" {

    bucket = aws_s3_bucket.project_buckets.id
    key = "image.png"
    source = "image.png"
    acl = "public-read"
  
}

resource "aws_s3_bucket_website_configuration" "s3_web_config" {
  bucket = aws_s3_bucket.project_buckets.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.s3_public_acl ]

}

