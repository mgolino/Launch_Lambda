resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "example" {
  # filename      = "lambda_function_payload.zip"  # Your Lambda function code
  function_name = "MyLambdaFunction"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_handler"

  # source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.12"
  # Other configurations like memory size, timeout, etc., can be added here
}
