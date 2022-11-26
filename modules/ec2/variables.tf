variable "aim_aws_instance" {
  description = "Canonical, Ubuntu, 20.04 LTS, amd64 focal image build on 2021-11-29"
  default = "ami-04505e74c0741db8d"
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

variable "key_aws_instance" {
  description = "Path ssh key"
  default     = "ssh-gui" 
}

variable "count_instances" {
  default = 2
}

variable "source_ansible" {
  description = "Source folder with content files ansible"
  default = "ansible/"
}

variable "dest_ansible" {
  description = "Destination folder in instance with files ansible"
  default = "/home/ubuntu/ansible" 
}
