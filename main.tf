resource "aws_lambda_function" "example" {
  # filename      = "lambda_function_payload.zip"  # Your Lambda function code
  function_name = "MyLambdaFunction"
  role          = aws_iam_role.Lambda-Role-MPG.arn
  handler       = "lambda_handler"

  # source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.12"
  # Other configurations like memory size, timeout, etc., can be added here
}
