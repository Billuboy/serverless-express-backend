resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.express_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = var.gw_source_arn
}

# Creating CloudWatch Log group for Lambda function.
resource "aws_cloudwatch_log_group" "lambda_log_grp" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 30
}

# Creating a Lambda trust policy so that we can attach IAM policy to the Lambda function.
data "aws_iam_policy_document" "lambda_trust_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Lambda resource access IAM role.
# data "aws_iam_policy_document" "lambda_access_policy" {
#   statement {
#     effect = "Allow"

#     resources = [aws_cloudwatch_log_group.lambda_log_grp.arn]

#     actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
#   }
# }

# Creating IAM role for Lambda function
resource "aws_iam_role" "lambda_iam_role" {
  name               = "express-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_policy.json

  # inline_policy {
  #   name   = "lambda-resource-access-policy"
  #   policy = data.aws_iam_policy_document.lambda_access_policy.json
  # }
}

# Attaching LambdaBasicExecutionRole to the IAM policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution_policy" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# If you want to delegate the zipping task to terraform then,
#  please use the below code block.
# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = "../out"
#   output_path = "../artifacts/lambda.zip"
# }

# Creating Lambda function to host the express server.
resource "aws_lambda_function" "express_lambda" {
  filename      = "../artifacts/lambda.zip"
  function_name = var.lambda_name
  role          = aws_iam_role.lambda_iam_role.arn
  handler       = "lambda.handler"
  timeout       = 30
  memory_size   = 128
  publish       = var.enable_versioning

  ephemeral_storage {
    size = 512
  }

  source_code_hash = filebase64sha256("../artifacts/lambda.zip")
  # In case you are using hashicorp/archive to archive the files
  #  data.archive_file.lambda_zip.output_base64sha256

  runtime = "nodejs18.x"

  environment {
    variables = {
      API_ENV        = var.api_env
      DB_CONN_STRING = var.db_conn_string
    }
  }
}