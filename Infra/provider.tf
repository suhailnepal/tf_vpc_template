terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  /*
  backend "s3" {
    bucket         = "ssandbox-terraform-state"
    region         = "ap-southeast-2"
    dynamodb_table = "ssandbox-state-lock-dynamo"
  }
  */
}

provider "aws" {
  region  = var.region
  profile = var.profile
}
