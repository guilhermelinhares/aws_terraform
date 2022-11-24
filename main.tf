terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.3.5"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2_instance" {
  source = "./modules/ec2"
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.subnet_id
}

module "rds" {
  source = "./modules/rds"
  
}