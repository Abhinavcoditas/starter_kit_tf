terraform {
  # backend "s3" {
  #   bucket         = "<BUCKET_NAME>"
  #   encrypt        = true
  #   key            = "<PATH_TO_TFSTATE>"
  #   region         = "var.aws-region"
  # }


  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region              = var.aws-region
  profile             = var.profile
}