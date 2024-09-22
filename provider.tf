terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "eu-west-3" # Specify the AWS region where resources will be created (you can change this)
  access_key = "  "
  secret_key = "  "
}
