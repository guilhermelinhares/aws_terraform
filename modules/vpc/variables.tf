variable "region" {
  default = "us-east-1"
}

variable "vpc_main_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_main_public_cidr_a" {
  default = "10.0.101.0/24"
}

variable "vpc_main_public_cidr_b" {
  default = "10.0.102.0/24"
}

variable "vpc_main_private_cidr_a" {
  default = "10.0.1.0/24"
}
variable "vpc_main_private_cidr_b" {
  default = "10.0.2.0/24"
}

variable "name_security_group_ec2" {
  description = "Security Group Ec2"
  default     = "aws_security_group_ec2"
}

variable "name_security_group_rds" {
  description   = "Security Group Rds"
  default       = "aws_security_group_rds"
}

variable "name_security_group_sections" {
  description   = "Security Group Sections"
  default       = "aws_security_group_sections"
}

variable "rds_port" {
  description   = "Port of rds"
  default       = "3306"
}