
# API Gateway HTTP API for less cost and easy configuration.
resource "aws_apigatewayv2_api" "api_gw" {
  name          = "express-api-gateway"
  protocol_type = "HTTP"
}

# This block will create an API stage in the API Gateway.
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api_gw.id
  name        = var.api_env
  auto_deploy = true
}

# This code block will create an integration for the API Gateway.
resource "aws_apigatewayv2_integration" "api_integration" {
  api_id = aws_apigatewayv2_api.api_gw.id
  # Since, we are using Gateway to proxy for an AWS Service (Lambda).
  integration_type = "AWS_PROXY"
  # Lambda integration only works with POST method.
  # API Gateway uses POST method to invoke lambda function with the gateway event
  integration_method = "POST"
  # Express Lambda ARN
  integration_uri = var.express_lambda_arn
}

# API Gateway catch all route.
# Using ANY /{proxy+} to transfer the routing logic to the underlying express server. 
resource "aws_apigatewayv2_route" "gw_catch_all_route" {
  api_id = aws_apigatewayv2_api.api_gw.id

  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.api_integration.id}"
}