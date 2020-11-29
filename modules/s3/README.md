# AWS S3 Setup

This module contains the S3 buckets necessary for the OpenedX instance to work. These are two
separated buckets one for course storage and the other for tracking logs.

## Input

The following inputs are just for customization, they need to be provided, but they are not
essential for the functioning of the module:

- `customer_name`
- `environment`: `prod` for example

## Output

Most of these output variables are necessary for the OpenedX installation/configuration, they should
have to be added to the `vars.yml` file in the respective variables:

- `s3_storage_bucket_name`: Name of the storage bucket, necessary for an OpenedX instance. To be set in the
`EDXAPP_AWS_STORAGE_BUCKET_NAME` variable
- `s3_storage_user_access_key`: Access Key ID for the created AWS user with the respective access to the
`s3_storage_bucket_name` bucket. To be set in the `AWS_ACCESS_KEY_ID` variable
- `s3_storage_user_secret_key`: Respective Secret Access Key to `s3_storage_user_access_key`. To be set
in the `AWS_SECRET_ACCESS_KEY` variable
- `s3_tracking_logs_bucket_name`: Name of the storage bucket, necessary for an OpenedX instance. To be set
in the `COMMON_OBJECT_STORE_LOG_SYNC_BUCKET` variable
- `s3_tracking_logs_user_access_key`: To be set in the `AWS_S3_LOGS_ACCESS_KEY_ID` variable
- `AWS_S3_LOGS_SECRET_KEY`: To be set in the `AWS_S3_LOGS_SECRET_KEY` variable
