output "instance_id" {
  value       = aws_instance.aws_ec2.*.id
}