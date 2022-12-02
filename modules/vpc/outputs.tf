output "vpc_id" {
  description     = "ID VPC"
  value           = aws_vpc.main.id
}

output "security_group_ec2_id" {
  description     = "ID of SG EC2"
  value           = aws_security_group.aws_security_group_ec2.id
}

output "aws_security_group_rds_id" {
  description     = "ID of SG RDS"
  value           = aws_security_group.aws_security_group_rds.id
}

output "aws_security_group_sections_id" {
  description     = "ID of SG Sections"
  value           = aws_security_group.aws_security_group_sections.id
}

output "aws_security_group_efs_id" {
  description     = "ID of SG EFS"
  value           = aws_security_group.aws_security_group_efs.id
}

output "public_subnet_id_a" {
  description     = "Public IP Subnet AZ-A"
  value           = aws_subnet.main_public_subnet_a.id
}

output "public_subnet_id_b" {
  description     = "Public IP Subnet AZ-B"
  value           = aws_subnet.main_public_subnet_b.id
}

output "private_subnet_id_a" {
  description     = "Private IP Subnet AZ-A"
  value           = aws_subnet.main_private_subnet_a.id
}

output "private_subnet_id_b" {
  description     = "Private IP Subnet AZ-B"
  value           = aws_subnet.main_private_subnet_b.id
}

output "private_subnet_ids" {
  description     = "Private IP Subnet AZ-A + AZ-B"
  value           = ["${aws_subnet.main_private_subnet_a.id}","${aws_subnet.main_private_subnet_b.id}"]
}

output "public_subnet_ids" {
  description     = "Public IP Subnet AZ-A + AZ-B"
  value           = ["${aws_subnet.main_public_subnet_a.id}","${aws_subnet.main_public_subnet_b.id}"]
}