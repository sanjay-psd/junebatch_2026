provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "skp-bucket-dev-11"
    key    = "devjune2026.tfstate"
    region = "us-east-1"
  }
}

