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

resource "aws_iam_role" "iam_for_lambda" {
    name = "iam_for_lambda"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
    type = "zip"
    source_file = "../lambda/lambda.py"
    output_path = "lambda_function_src.zip"
}

/* resource "aws_vpc" "VPCMPG" {
  cidr_block = "172.31.0.0/16"
}

resource "aws_subnet" "SUBNETVPC" {
  vpc_id     = aws_vpc.VPCMPG.id
  cidr_block = "172.31.16.0/20"
}*/

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_lambda_function" "lambda" {
    filename = "lambda_function_src.zip"
    function_name = "python_terraform_lambda"
    role = aws_iam_role.iam_for_lambda.arn
    source_code_hash = data.archive_file.lambda.output_base64sha256

    runtime = "python3.10"
    handler = "lambda_handler"

   vpc_config {
    vpc_id = data.aws_vpc.selected.id
    subnet_ids = ["${var.subnet_ids}"]
    security_group_ids = ["${var.security_group_ids}"]
#        subnet_ids = "subnet-0e10efe028772a50d.id"
#        security_group_ids = "sg-0f54cfef2abad9ffe.id"
    }
}
