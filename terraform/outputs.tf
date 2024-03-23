output "gw_invoke_url" {
  description = "Base URL for API Gateway stage."
  value       = module.api_gateway.gw_invoke_url
}

output "sever_health_route" {
  description = "Health route for deployed server."
  value       = module.api_gateway.sever_health_route
}