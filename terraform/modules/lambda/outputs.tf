# Exporting lambda invoke arn so, that API Gateway can use it for the integration.
output "express_lambda_arn" {
  value = aws_lambda_function.express_lambda.invoke_arn
}