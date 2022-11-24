variable "aim_aws_instance" {
  description = "Ubuntu Server 20.04 LTS (HVM), SSD Volume Type"
  default = "ami-0149b2da6ceec4bb0"
}

variable "region" {
  default = "us-east-1"
}

variable "instance_type_aws_instance" {
  description = "Instance T2 Micro 1-vCPUs/1GB-Ram "
  default = "t2.micro"
}

variable "name_security_group" {
  description = "Security Group"
  default = "allow_traffic"
}
 
variable "vpc_id" {
  description = "Vpc_ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet_ID"
  type        = string
}