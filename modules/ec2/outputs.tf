output "instance_id" {
  description = "ID of instances"
  value       = aws_instance.aws_ec2.*.id
}

output "instances_public_ip" {
  description = "Ip of instances"
  value       = aws_instance.aws_ec2.*.public_ip
}

output "count_instances" {
  description   = "Count of instances"
  value         = var.count_instances
}