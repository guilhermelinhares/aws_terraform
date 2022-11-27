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
  source              = "./modules/ec2"
  vpc_id              = module.vpc.vpc_id
  subnet_id           = module.vpc.public_subnet_id_a

  depends_on          = [module.vpc.vpc_id]
}

# module "rds" {
#   source                = "./modules/rds"

#   vpc_id                = module.vpc.vpc_id
#   subnet_ids            = ["${module.vpc.private_sub_a_id}","${module.vpc.private_sub_b_id}"]
#   rds_sub_groups_id     = module.rds.rds_sub_groups_id
#   ec2_security_group_id = module.ec2_instance.security_group_id

#   depends_on            = [module.vpc.vpc_id, module.ec2_instance.ec2_security_group_id]
# }