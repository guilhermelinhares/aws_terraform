#region - Output Module VPC
  output "vpc_id" {
    description     = "Id VPC"
    value           = module.vpc.vpc_id
  }

  output "private_subnet_ids" {
    description     = "Private ip subnet AZ-A + AZ-B"
    value           = ["${module.vpc.private_subnet_id_a}","${module.vpc.private_subnet_id_b}"]
  }

  output "public_subnet_ids" {
    description     = "Public ip subnet AZ-A + AZ-B"
    value           = ["${module.vpc.public_subnet_id_a}","${module.vpc.public_subnet_id_b}"]
  }

  output "aws_security_group_ec2" {
    description     = "Return ID of SG Ec2"
    value           = module.vpc.security_group_ec2_id
  }

  output "rds_security_group_id" {
    description     = "SG RDS ID"
    value = module.vpc.aws_security_group_rds_id
  }
#endregion

#region - Output Module Ec2
  
  output "instance_id" {
    description   = "Instance ID"
    value         = [module.ec2_instance.*.instance_id]
  }

  output "instances_public_ip" {
    description   = "Instance public IP(s)"
    value         = module.ec2_instance.*.instances_public_ip
  }

  output "count_instances" {
    description   = "Count of instances"
    value         = module.ec2_instance.count_instances
  }

#endregion

#region - Output Module RDS

  output "rds_id" {
    description   = "RDS Identifier"
    value         = module.rds.rds_id
  }

  output "password_db" {
    description   = "Gen password"
    value         = module.rds.password_db
    sensitive     = true
  }

  output "rds_sub_groups_id" {
    description   = "Return ID subnet group"
    value         = module.rds.rds_sub_groups_id
  }

#endregion

#region - Output Module Elasticache

output "endpoint" {
  description     = "Enpoint name Memcached"
  value           = module.elasticache.endpoint
}
#endregion

#region - Output Module EFS
  output "dns_name" {
    description   = "Name of DNS EFS"
    value         = module.efs.dns_name
  }
#endregion

#region - Output Module S3
  output "web_s3_endpoint" {
    description     = "Website Endpoint Bucket S3"
    value           =  module.s3.web_s3_endpoint
  }

  output "cn_domain_name" {
    description = "CloudFront Domain"
    value = module.s3.cn_domain_name
  }
#endregion