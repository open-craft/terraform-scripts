output "edxapp_s3_bucket" {
  value = aws_s3_bucket.edxapp
}

output "edxapp_s3_user_access_key" {
  value = aws_iam_access_key.edxapp_s3_access_key
}

output "edxapp_tracking_logs_s3_bucket" {
  value = aws_s3_bucket.edxapp_tracking_logs
}

output "edxapp_tracking_logs_s3_user_access_key" {
  value = aws_iam_access_key.edxapp_tracking_logs_s3_access_key
}

output "edxapp_course_discovery_s3_access_key" {
  value = var.enable_course_discovery ? aws_iam_access_key.edxapp_course_discovery_s3_access_key : null
}
