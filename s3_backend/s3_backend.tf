terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  access_key = "AKIATLNZLTYIXY4VIQOF"
  secret_key = "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"
  region = "us-east-2"
  shared_credentials_file = "~/Users/fnolla/.aws/credentials"
  profile = "circle-ci-user"
}

resource "random_uuid" "randomid" {}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${random_uuid.randomid.result}-backend"
  # Enable versioning so we can see the full revision history of our
  # state files
  force_destroy = true
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}
