terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.7"
    }
  }
  required_version = ">= 0.13"
}
