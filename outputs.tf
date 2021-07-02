output "iam_role_arn" {
  description = "ARN of IAM eks autoscaler role"
  value       = aws_iam_role.this.arn
}
