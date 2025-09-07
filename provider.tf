

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }

  backend "s3" {
    bucket = "kavyas-remote-state-dev"
    key    = "expense-cicd" # you should have unique keys with in the bucket, same key should not be used in other repos or tf projects
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}