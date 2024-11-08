# output "lambda_function_arn" {
#   value       = data.aws_lambda_function.iam_for_lambda.arn
#   description = "Lambda ARN"
# }

output "lambda_function_url" {
  value = aws_lambda_function_url.example_url.function_url
}

output "lambda_function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "log_bucket_name" {
  value = aws_s3_bucket.lambda_logs.bucket
}