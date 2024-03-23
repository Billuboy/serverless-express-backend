# Exporting gw_source_arn so that lambda can use it in the lambda permissions. 
output "gw_source_arn" {
  value = "${aws_apigatewayv2_api.api_gw.execution_arn}/*/*"
}

output "gw_invoke_url" {
  value = aws_apigatewayv2_stage.api_stage.invoke_url
}

output "sever_health_route" {
  value = "${aws_apigatewayv2_stage.api_stage.invoke_url}/health"
}