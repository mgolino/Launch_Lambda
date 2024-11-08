# data "aws_vpc" "default" {
#     default = true
# }

# data "aws_subnets" "subnets" {
#   filter {
#     name = "default"
#     values = [data.aws_vpc.default.id]
#   }
# }
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
  
data "aws_iam_role" "iam_for_lambda" {
  name = "PopularRoleLambdaExecution"
}

data "aws_iam_policy_document" "assume_role" {
    statement {
        effect = "Allow"

        principals {
            type = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}

#resource "aws_iam_role" "iam_for_lambda" {
#    name = "iam_for_lambda"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
#}

# resource "aws_iam_role_policy_attachment" "attach_role" {
#    role = data.aws_iam_role.iam_for_lambda.arn
    # policy_arn = "arn:aws:iam::503102121832:role/PopularRoleLambdaExecution"
# }

data "archive_file" "lambda" {
    type = "zip"
    source_file = "lambda_function.py"
    output_path = "lambda_function.zip"
}

/* resource "aws_vpc" "VPCMPG" {
  cidr_block = "172.31.0.0/16"
}

resource "aws_subnet" "SUBNETVPC" {
  vpc_id     = aws_vpc.VPCMPG.id
  cidr_block = "172.31.16.0/20"
}*/

resource "aws_lambda_function" "lambda" {
    filename = "lambda_function.zip"
    function_name = "python_MPG_lambda2"
    role = data.aws_iam_role.iam_for_lambda.arn
    source_code_hash = data.archive_file.lambda.output_base64sha256

    runtime = "python3.12"
    handler = "lambda_function.lambda_handler"

    # environment {
    # variables = {
    #   secrets = "mpg-variable"
    # }
    environment {
    variables = {
        LOG_BUCKET = aws_s3_bucket.lambda_logs.bucket
    }
    
  }

    vpc_config {
    # vpc_id = data.aws_vpc.subnets.id
    subnet_ids = ["${var.subnet_ids}"]
    security_group_ids = ["${var.security_group_ids}"]
#        subnet_ids = "subnet-0e10efe028772a50d.id"
#        security_group_ids = "sg-0f54cfef2abad9ffe.id"
    }

    tags = {
    Environment = "Dev"
    Name = "MyLambdaFunction"
  }
}

resource "aws_lambda_function_url" "example_url" {
  function_name      = aws_lambda_function.lambda.function_name
  authorization_type = "NONE"
  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}
 
 # Create S3 Bucket for Lambda logs
resource "aws_s3_bucket" "lambda_logs" {
  bucket = "lambda-logs-${random_id.bucket_id.hex}"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "Lambda Log Bucket"
    Environment = "Development"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 8
}

resource "aws_s3_bucket_ownership_controls" "lambda_logs" {
  bucket = aws_s3_bucket.lambda_logs.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "lambda_logs" {
  bucket = aws_s3_bucket.lambda_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_iam_policy" "log_policy" {
  name        = "lambda-log-to-s3"
  path        = "/"
  description = "IAM policy for logging into S3 from a lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        Effect   = "Allow",
        Resource = "${aws_s3_bucket.lambda_logs.arn}/*"
      }
    ]
  })
}

# # Attach the policy to the role
# resource "aws_iam_role_policy_attachment" "lambda_logs" {
#   role       = aws_iam_role.lambda_exec.name
#   policy_arn = aws_iam_policy.log_policy.arn
# }
