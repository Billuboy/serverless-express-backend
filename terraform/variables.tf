variable "api_env" {
  type        = string
  description = "Please enter environment for APIs"
  default     = "production"
}

variable "db_conn_string" {
  type        = string
  description = "Please enter value for database connection string"
  default     = "${"postgres"}://${"user"}:${"password"}@${"localhost"}:${"5432"}/${"test"}"
}

variable "lambda_name" {
  type        = string
  description = "Please enter a name for lambda"
  default     = "express-lambda"
}

variable "enable_versioning" {
  type        = bool
  description = "Do you want to enable versioning for lambda?"
  default     = true
}