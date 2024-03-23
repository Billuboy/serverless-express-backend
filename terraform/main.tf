# Configuration for AWS provider.
provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      "provisioned_through" = "terraform"
    }
  }
}

# Modules

# 1. API Gateway Module
module "api_gateway" {
  source = "./modules/api-gateway"

  api_env            = var.api_env
  express_lambda_arn = module.lambda.express_lambda_arn
}

# 2. Lambda Module
module "lambda" {
  source = "./modules/lambda"

  api_env           = var.api_env
  db_conn_string    = var.db_conn_string
  enable_versioning = var.enable_versioning
  lambda_name       = var.lambda_name
  gw_source_arn     = module.api_gateway.gw_source_arn
}