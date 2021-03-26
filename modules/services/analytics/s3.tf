data "aws_iam_policy_document" "get-s3-grades-policy-document" {
  version = "2008-10-17"

  statement {
    actions = [
      "s3:GetObject",
    ]

    principals {
      type = "AWS"
      identifiers = [
        var.edxapp_s3_grade_user_arn,
      ]
    }

    resources = [
      "${var.edxapp_s3_grade_bucket_arn}/grades-download/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "edxapp-grade-bucket-policy" {
  bucket = var.edxapp_s3_grade_bucket_id
  policy = data.aws_iam_policy_document.get-s3-grades-policy-document.json
}

########## EMR used buckets ##########
resource "aws_s3_bucket" "emr" {
  bucket = "${var.customer_name}-${var.environment}-emr"
}

resource "aws_s3_bucket" "emr-logs" {
  bucket = "${var.customer_name}-${var.environment}-emr-logs"
}

resource "aws_s3_bucket" "edxanalytics" {
  bucket = "${var.customer_name}-edx${var.environment}"
}

resource "aws_s3_bucket" "api-reports" {
  bucket = "${var.customer_name}-${var.environment}-api-reports"
}
