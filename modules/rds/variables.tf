variable "vpc_id" {
  description   = "Vpc_ID"
  type          = string
}

variable "rds_instance_identifier" {
  description   = "Name of RDS"
  default       = "db-wp"
}

variable "name_security_group" {
  description   = "Security Group"
  default       = "allow_traffic_rds"
}
 

variable "subnet_ids" {
  description   = "Subnet_ID"
  type          = list    
}

variable "db_name" {
  description   = "DB Name"
  default       = "wp_db"
}

variable "db_user" {
  description   = "Username DB"
  default       = "wp_user"
}

variable "db_engine_type" {
  description   = "Engine type DB"
  default       = "mysql"
}

variable "instance_type_aws_db_instance" {
  description   = "Instance T3 Micro"
  default       = "db.t3.micro"
}

variable "db_engine_version" {
  description   = "Version DB Schema"
  default       = "5.7.40"
}

variable "storage_type" {
  description   = "Type of Storage gp2 || gp3 || io1"
  default       = "gp2"
}

variable "allocated_storage" {
  description   = "Size of disc storage - Minimum value is 20gb"
  default       = "20"
}

variable "rds_port" {
  description   = "Port of rds"
  default       = "3306"
}

variable "rds_sub_groups_id" {
  description   = "ID os subnet groups"
}

variable "ec2_security_group_id" {
  description   = "ID of security group"
}

# variable "source_template_wp" {
#   description = "Source folder with content template rds"
#   default = "modules/rds/templates/"
# }

# variable "wp_files" {
#   description = "Destination wp-config changed"
#   default = "/home/ubuntu/ansible/roles/install_wordpress/files" 
# }

# variable "instances_public_ip" {
#   description = "Public ip instances"
# }

# variable "key_aws_instance" {
#   description = "Path ssh key"
#   default     = "ssh-gui" 
# }

# variable "count_instances" {
#   description   = "Count of instances"
# }