output "iam_role_arn" {
  description = "ARN of IAM eks autoscaler role"
  value       = aws_iam_role.this.arn
}

output "lc_test" {
  description = "ARN of IAM eks autoscaler role"
  value       = "-${data.aws_ssm_parameter.this_gpu.value}-"
}
