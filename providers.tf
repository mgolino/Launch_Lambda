terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "us-west-1"
  vpc_id = "vpc-0f5ebef494a1a8c30"
  vpc_cidr_block = "172.31.0.0/16"
}
