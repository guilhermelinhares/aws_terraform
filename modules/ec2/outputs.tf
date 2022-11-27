output "instance_id" {
  description = "ID of instances"
  value       = aws_instance.aws_ec2.*.id
}

output "instances_public_ip" {
  description = "Ip of instances"
  value       = aws_instance.aws_ec2.*.public_ip
}

output "security_group_id" {
  description   = "ID of sg"
  value         = aws_security_group.allow_traffic.id
}