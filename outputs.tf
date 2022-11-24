output "vpc_id" {
  value       = module.vpc.vpc_id
}

output "instance_id" {
  value       = module.ec2_instance.*.instance_id
}

output "rds_id" {
  value = ""
}