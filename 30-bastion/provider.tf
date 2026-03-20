terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.35.1"
    }
    
  }
   backend "s3" {
    bucket = "remote-state-saidevops"
    key    = "remote-dev-bastion"
    region = "us-east-1"
    encrypt=true
    use_lockfile=true
  }
}


provider "aws" {
  region = "us-east-1"
}