output "s3_storage_bucket_name" {
  value = aws_s3_bucket.edxapp.bucket
}

output "s3_storage_user_access_key" {
  value = aws_iam_access_key.edxapp_s3_access_key.id
}

output "s3_storage_user_secret_key" {
  value = aws_iam_access_key.edxapp_s3_access_key.secret
}

output "s3_tracking_logs_bucket_name" {
  value = aws_s3_bucket.edxapp_tracking_logs.bucket
}

output "s3_tracking_logs_user_access_key" {
  value = aws_iam_access_key.edxapp_tracking_logs_s3_access_key.id
}

output "s3_tracking_logs_user_secret_key" {
  value = aws_iam_access_key.edxapp_tracking_logs_s3_access_key.secret
}

output "s3_discovery_bucket_name" {
  value = aws_s3_bucket.edxapp_discovery.bucket
}

output "s3_discovery_user_access_key" {
  value = aws_iam_access_key.edxapp_discovery_s3_access_key.id
}

output "s3_discovery_user_secret_key" {
  value = aws_iam_access_key.edxapp_discovery_s3_access_key.secret
}
