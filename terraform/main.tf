#  TODO: 1. Add proper comments for all the resouces.
#  TODO: 2. Implement versioned deployements for lambda.

# Providers
provider "aws" {
  region = "ap-south-1"
}

# Resources

# API Gateway
resource "aws_apigatewayv2_api" "api_gw" {
  name = "express-api-gateway"
  # Protocol type HTTP for HTTP API Gateway.
  protocol_type = "HTTP"
}

# Analogies:
# API Gateway Route -> REST API Endpoint
# API Gateway Method -> REST API Methods (GET, POST, etc.)

# This block creates a resouce in API Gateway.
# A resource in a gateway is an endpoint. 
# Since, we want to fallback to express router, we won't be creating any resouce in gateway. 

# This block will create a method for the specified resource.
# We are using ANy because, we want to fallback to express router.
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api_gw.id
  name        = var.api_env
  auto_deploy = true
}

# This code block will create an integration for the method in particular resource.
# Since, we want to use Lambda for handling incoming requests, 
# we have to create a Lambda integration for the specified method.
resource "aws_apigatewayv2_integration" "apis_integration" {
  api_id = aws_apigatewayv2_api.api_gw.id
  # Since, we are using Gateway to proxy for an AWS Service (Lambda).
  integration_type   = "AWS_PROXY"
  # Lambda integration only works with POST method.
  integration_method = "POST"

  # Express Lambda ARN
  integration_uri    = aws_lambda_function.express_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "gw_catch_all_route" {
  api_id = aws_apigatewayv2_api.api_gw.id

  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.apis_integration.id}"
}

# Lambda
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.express_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gw.execution_arn}/*/*"
}

resource "aws_cloudwatch_log_group" "lambda_log_grp" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 30
}

# Lambda trust policy
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

resource "aws_iam_role" "lambda_iam_role" {
  name = "express-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_policy.json

  # inline_policy {
  #   name   = "lambda-resource-access-policy"
  #   policy = data.aws_iam_policy_document.lambda_access_policy.json
  # }
}

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

resource "aws_lambda_function" "express_lambda" {
  filename      = "../artifacts/lambda.zip"
  function_name = var.lambda_name
  role          = aws_iam_role.lambda_iam_role.arn
  handler       = "lambda.handler"
  timeout       = 30
  memory_size   = 256

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