output "vpc_id" {
  value       = module.vpc.vpc_id
}

output "instance_id" {
  value       = module.ec2_instance.*.instance_id
}

output "instances_public_ip" {
  value = module.ec2_instance.*.instances_public_ip
}

output "rds_id" {
  value = ""
}