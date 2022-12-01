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
 
variable "vpc_id" {
  description = "Vpc_ID"
  type        = string
}

variable "subnet_id" {
  description = "Public Subnet Id"
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

variable "public_subnet_id_a" {
  description = "Public Subnet AZ-A"
}

variable "public_subnet_id_b" {
  description = "Public Subnet AZ-B"
}

variable "private_subnet_id_a" {
  description = "Private Subnet AZ-A"
}

variable "private_subnet_id_b" {
  description = "Private Subnet AZ-B"
}

variable "source_template_wp" {
  description = "Source folder with content template rds"
  default = "modules/rds/templates/"
}

variable "wp_files" {
  description = "Destination wp-config changed"
  default = "/home/ubuntu/ansible/roles/install_wordpress/files" 
}

variable "source_template_elasticache" {
  description = "Source folder with content template elasticache"
  default = "modules/elasticache/templates/"
}

variable "php_files" {
  description = "Destination php.ini changed"
  default = "/home/ubuntu/ansible/roles/install_wordpress/files" 
}


variable "aws_security_group_ec2" {
  description = "Security Group Ec2"
}

variable "dns_efs" {
  description = "DNS EFS"
}

variable "name_asg" {
  description = "Name Auto-Scaling Group"
  default     =  "ec2-asg"  
}

variable "name_launch_tpl" {
  description   = "Name Launch Template"
  default       = "launch_tpl"
}


#region - Load Balancer

  variable "name_lb" {
    description   = "Name of LoadBalancer"  
    default       = "aws-lb"
  } 

  variable "lb_type" {
    description = "The type of load balancer to create. Values -> application || gateway || network"
    default     = "network" 
  }


  variable "ipv4_public_cidr_a" {
    default = "10.0.101.15"
  }

  variable "ipv4_public_cidr_b" {
    default = "10.0.102.15"
  }

  variable "aws-lb-tg-http" {
    description   = "TG PT 80"
    default       = "aws-lb-tg-http"
  }

  variable "aws-lb-tg-https" {
    description   = "TG PT 443"
    default       = "aws-lb-tg-https"
  }

#endregion