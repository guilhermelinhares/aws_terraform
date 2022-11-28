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


module "rds" {
  source                = "./modules/rds"

  vpc_id                = module.vpc.vpc_id
  subnet_ids            = ["${module.vpc.private_sub_a_id}","${module.vpc.private_sub_b_id}"]
  rds_sub_groups_id     = module.rds.rds_sub_groups_id
  ec2_security_group_id = module.ec2_instance.security_group_id
  # count_instances       = module.ec2_instance.count_instances
  # instances_public_ip   = "${element(module.ec2_instance.*.instances_public_ip,module.ec2_instance.count_instances)}"
  
  depends_on            = [module.vpc.vpc_id, module.ec2_instance.ec2_security_group_id]
}

/**
* Doc
* https://developer.hashicorp.com/terraform/language/functions/element
*/
module "ec2_instance" {

  source              = "./modules/ec2"
  vpc_id              = module.vpc.vpc_id
  public_subnet_id_a  = module.vpc.public_subnet_id_a
  public_subnet_id_b  = module.vpc.public_subnet_id_b
  subnet_id           = "${element(module.vpc.public_subnet_ids,module.ec2_instance.count_instances)}"

  depends_on          = [module.vpc.vpc_id,module.rds.id]
}