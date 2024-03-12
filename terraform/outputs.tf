output "gw_invoke_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.api_stage.invoke_url
}

output "sever_health_route" {
  description = "Health route for deployed server."

  value = "${aws_apigatewayv2_stage.api_stage.invoke_url}/health"
}