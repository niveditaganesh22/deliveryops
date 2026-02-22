output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}

output "state_key" {
  value = "deliveryops/preview/pr-${var.pr_number}.tfstate"
}
