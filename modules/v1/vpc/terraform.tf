provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.13.5"
}