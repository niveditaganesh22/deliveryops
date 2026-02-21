output "state_bucket_name" {
  value = aws_s3_bucket.tf_state.bucket
}

output "lock_table_name" {
  value = aws_dynamodb_table.tf_locks.name
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github.arn
}

output "role_dev_arn" {
  value = aws_iam_role.deliveryops_dev.arn
}

output "role_stage_arn" {
  value = aws_iam_role.deliveryops_stage.arn
}
