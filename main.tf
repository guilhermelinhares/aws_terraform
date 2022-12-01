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
  source                   = "./modules/rds"

  subnet_ids               = ["${module.vpc.private_subnet_id_a}","${module.vpc.private_subnet_id_b}"]
  rds_sub_groups_id        = module.rds.rds_sub_groups_id
  aws_security_group_ec2   = module.vpc.security_group_ec2_id
  aws_security_group_rds   = module.vpc.aws_security_group_rds_id

  depends_on               = [module.vpc]
}

module "elasticache" {
  source = "./modules/elasticache"

  private_subnet_id_a   = module.vpc.private_subnet_id_a
  private_subnet_id_b   = module.vpc.private_subnet_id_b

  # depends_on            = [module.vpc]
  depends_on            = [module.vpc, module.rds]
}


module "efs" {

  source = "./modules/efs"

  private_subnet_id_a      = module.vpc.private_subnet_id_a
  private_subnet_id_b      = module.vpc.private_subnet_id_b
  vpc_id                   = module.vpc.vpc_id
  aws_security_group_efs   = module.vpc.aws_security_group_efs_id

  depends_on               = [module.vpc]
}

/**
  * https://developer.hashicorp.com/terraform/language/functions/element
*/
module "ec2_instance" {

  source                   = "./modules/ec2"

  vpc_id                   = module.vpc.vpc_id
  public_subnet_id_a       = module.vpc.public_subnet_id_a
  public_subnet_id_b       = module.vpc.public_subnet_id_b
  subnet_id                = "${element(module.vpc.public_subnet_ids,module.ec2_instance.count_instances)}"
  aws_security_group_ec2   = module.vpc.security_group_ec2_id
  dns_efs                  = module.efs.dns_name

  # depends_on               = [module.vpc, module.elasticache, module.efs]
  depends_on               = [module.vpc,module.rds, module.elasticache, module.efs]
}

module "alb" {
  source                    = "./modules/alb"
  
  count_instances           = module.ec2_instance.count_instances 
  instance_id               = element(module.ec2_instance.*.instance_id, module.ec2_instance.count_instances)
  vpc_id                    = module.vpc.vpc_id
  public_subnet_id_a        = module.vpc.public_subnet_id_a
  public_subnet_id_b        = module.vpc.public_subnet_id_b

  depends_on                = [module.vpc, module.ec2_instance]
}