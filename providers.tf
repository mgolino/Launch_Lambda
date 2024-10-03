terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "us-west-1"
  aws_vpc = "vpc-0f5ebef494a1a8c30"
}
