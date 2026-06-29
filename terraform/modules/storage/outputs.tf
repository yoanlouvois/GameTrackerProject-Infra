output "mysql_backups_bucket_name" {
  value = aws_s3_bucket.mysql_backups.bucket
}

output "mysql_backups_bucket_arn" {
  value = aws_s3_bucket.mysql_backups.arn
}