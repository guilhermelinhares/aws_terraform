variable "name_lb" {
  description   = "Name of LoadBalancer"  
  default       = "aws-lb"
} 

variable "lb_type" {
  description = "The type of load balancer to create. Values -> application || gateway || network"
  default     = "network" 
}

variable "vpc_id" {
  description = "Vpc_ID"
  type        = string
}

variable "public_subnet_id_a" {
  description = "Public Subnet AZ-A"
}

variable "public_subnet_id_b" {
  description = "Public Subnet AZ-B"
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

variable "count_instances" {
  description = "Number of instances"
}

variable "instance_id" {
  type        = list(string) 
  description = "ID of instances"
}