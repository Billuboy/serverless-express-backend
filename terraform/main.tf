# Providers
provider "aws" {
  region = "ap-south-1"
}

# Resources

# API Gateway
resource "aws_api_gateway_rest_api" "api_gw" {
  name = "express-api-gateway"
  endpoint_configuration {
    # Type can be "EDGE" or "REGIONAL"
    types = ["REGIONAL"]
  }
}

# Analogies:
# API Gateway Resource -> REST API Endpoint
# API Gateway Method -> REST API Methods (GET, POST, etc.)

# This block creates a resouce in API Gateway.
# A resource in a gateway is an endpoint. 
# Since, we want to fallback to express router, we won't be creating any resouce in gateway. 
# resource "aws_api_gateway_resource" "resource" {
#   path_part   = "prod"
#   parent_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
#   rest_api_id = aws_api_gateway_rest_api.api_gw.id
# }

# This block will create a method for the specified resource.
# We are using ANy because, we want to fallback to express router.
resource "aws_api_gateway_method" "method" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  # As mentioned above, we are relying on express router for route resolution.
  # That is why, we are using root resouce id. 
  resource_id = aws_api_gateway_rest_api.api_gw.root_resource_id
  # If you've created a gateway resource, then please use this code block to pass the correct resource id. 
  # resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

# This code block will create an integration for the method in particular resource.
# Since, we want to use Lambda for handling incoming requests, 
# we have to create a Lambda integration for the specified method.
resource "aws_api_gateway_integration" "integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_rest_api.api_gw.root_resource_id
  http_method = aws_api_gateway_method.method.http_method
  # resource_id             = aws_api_gateway_resource.resource.id
  # Lambda integration only works with POST method.
  integration_http_method = "POST"
  # We are using Lambda Proxy to get the responses from the AWS Lambda.
  type = "AWS_PROXY"
  # Express Lambda ARN
  uri = aws_lambda_function.express_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "prod_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.method.id,
      aws_api_gateway_integration.integration.id,
    ]))
  }

    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_gw_prod_stage" {
  deployment_id = aws_api_gateway_deployment.prod_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
  stage_name    = "production"
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.express_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gw.execution_arn}/*"
  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  # source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}

resource "aws_cloudwatch_log_group" "lambda_log_grp" {
  name              = "express-lambda"
  retention_in_days = 30
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lamda_access_policy" {
    statement {
    effect = "Allow"

    resources = [aws_cloudwatch_log_group.lambda_log_grp.arn]

    actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "express-lambda-role"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name = "lambda-resource-access-policy"
    policy = data.aws_iam_policy_document.lamda_access_policy.json
  }
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
  function_name = "express-lambda"
  role          = aws_iam_role.iam_for_lambda.arn
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