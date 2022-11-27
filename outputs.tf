output "vpc_id" {
  description = "Id VPC"
  value       = module.vpc.vpc_id
}

output "instance_id" {
  description = "Instance ID"
  value       = module.ec2_instance.*.instance_id
}

output "instances_public_ip" {
  description = "Instance public IP(s)"
  value       = module.ec2_instance.*.instances_public_ip
}

# output "rds_id" {
#   description = "RDS Identifier"
#   value       = module.rds.rds_id
# }

# output "password_db" {
#   description = "Gen password"
#   value       = module.rds.password_db
#   sensitive   = true
# }

# output "rds_sub_groups_id" {
#   description = "Return ID subnet group"
#   value       = module.rds.rds_sub_groups_id
# }


output "private_sub_a_id" {
  description = "Private ip subnet AZ-A"
  value       = module.vpc.private_sub_a_id
}

output "private_sub_b_id" {
  description = "Private ip subnet AZ-B"
  value       = module.vpc.private_sub_b_id
}

output "public_subnet_id_a" {
  description = "Public IP Subnet AZ-A"
  value       = module.vpc.public_subnet_id_a
}

output "public_subnet_id_b" {
  description = "Public IP Subnet AZ-B"
  value       = module.vpc.public_subnet_id_b
}

output "ec2_security_group_id" {
  description = "Return ID of sg Ec2"
  value       = module.ec2_instance.security_group_id
}