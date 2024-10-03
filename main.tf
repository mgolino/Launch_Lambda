resource "aws_lambda_function" "example" {
  # filename      = "lambda_function_payload.zip"  # Your Lambda function code
  function_name = "MyLambdaFunction"
  role          = aws_iam_role.lambda_role.arn
  handler       = "exports.handler"  # This depends on your runtime

  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "nodejs14.x"  # Change this to your desired runtime
  # Other configurations like memory size, timeout, etc., can be added here
}
