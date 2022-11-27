output "vpc_id" {
  description     = "ID VPC"
  value           = aws_vpc.main.id
}

output "public_subnet_id_a" {
  description     = "Public IP Subnet AZ-A"
  value           = aws_subnet.main_public_subnet_a.id
}

output "public_subnet_id_b" {
  description     = "Public IP Subnet AZ-B"
  value           = aws_subnet.main_public_subnet_b.id
}

output "private_sub_a_id" {
  description     = "Private IP Subnet AZ-A"
  value           = aws_subnet.main_private_subnet_a.id
}

output "private_sub_b_id" {
  description     = "Private IP Subnet AZ-B"
  value           = aws_subnet.main_private_subnet_b.id
}