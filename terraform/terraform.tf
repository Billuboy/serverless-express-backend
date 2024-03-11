terraform {
  required_version = "= 1.7.4"

  required_providers {
    aws = {
      version = "= 5.40.0"
      source  = "hashicorp/aws"
    }

    archive = {
      version = "= 2.4.2"
      source  = "hashicorp/archive"
    }
  }
}