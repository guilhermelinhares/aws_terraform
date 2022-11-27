output "rds_id" {
  description = "ID of rds instances"
  value       = aws_db_instance.rds_db.id
}

output "password_db" {
  description = "Passwd db rds instance"
  value       = random_password.password.result
  sensitive = true
}

output "rds_address" {
  description = "Return the value of address RDS"
  value = aws_db_instance.rds_db.address
}

output "rds_sub_groups_id" {
  description = "Return the ID subnet group"
  value = aws_db_subnet_group.rds_sub_groups.id
}