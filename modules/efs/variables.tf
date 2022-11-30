variable "p_mode" {
  description   = "The file system performance mode. Modes -> generalPurpose || maxIO"
  default       =  "generalPurpose"
}

variable "name_efs" {
  description   = "Name of EFS"
  default       = "aws_efs"
}

variable "token" {
  description   = "A unique name used as reference when creating the Elastic File System"
  default       = "token_efs"
}

variable "th_mode" {
  description   = "Throughput mode for the file system -> bursting || provisioned || elastic"
  default       = "bursting" 
}

variable "vpc_id" {
  description = "Vpc_ID"
  type        = string
}

variable "private_subnet_id_a" {
  description = "Private Subnet AZ-A"
}

variable "private_subnet_id_b" {
  description = "Private Subnet AZ-B"
}

variable "aws_security_group_efs" {
  description = "SG EFS"
  type        = string
  
}