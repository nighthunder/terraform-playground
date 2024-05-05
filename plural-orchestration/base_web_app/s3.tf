# aws_s3_bucket
resource "aws_s3_bucket" "web_bucket" {
  bucket        = local.s3_bucket_name
  force_destroy = true
  tags          = local.common_tags
}
# aws_s3_bucket_policy
resource "aws_s3_bucket_policy" "web_bucket" {
  bucket     = aws_s3_bucket.web_bucket.id
  depends_on = [data.aws_elb_service_account.root]
  policy     = <<POLICY
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : { "AWS" : "${data.aws_elb_service_account.root.arn}" },
          "Action" : "s3:PutObject",
          "Resource" : "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*"
        },
        {
          "Effect" : "Allow",
          "Principal" : { "Service" : "delivery.logs.amazonaws.com" },
          "Action" : "s3:PutObject",
          "Resource" : "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*",
          "Condition" : {
            "StringEquals" : {
              "s3:x-amz-acl" : "bucket-owner-full-control"
            }
          }
        },
        {
          "Effect" : "Allow",
          "Principal" : { "Service" : "delivery.logs.amazonaws.com" },
          "Action" : "s3:GetBucketAcl",
          "Resource" : "arn:aws:s3:::${local.s3_bucket_name}"
        }
      ]
    }
  POLICY
}

# aws_s3_object

resource "aws_s3_object" "website" {
  bucket = aws_s3_bucket.web_bucket.bucket
  key    = "/website/index.html"
  source = "./website/index.html"

  tags = local.common_tags
}

resource "aws_s3_object" "graphics" {
  bucket = aws_s3_bucket.web_bucket.bucket
  key    = "/website/test-image.png"
  source = "./website/test-image.png"

  tags = local.common_tags
}

