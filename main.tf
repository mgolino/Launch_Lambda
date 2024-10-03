resource "aws_lambda_function" "example" {
  # filename      = "lambda_function_payload.zip"  # Your Lambda function code
  function_name = "MyLambdaFunction"
  role          = aws_iam_role.lambda_role.arn
  handler       = "exports.handler"  # This depends on your runtime

  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.12"
  # Other configurations like memory size, timeout, etc., can be added here
}
