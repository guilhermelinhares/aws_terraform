variable "region" {
  default = "us-east-1"
}

variable "profile" {
  default = "noprod"
}

variable "key_aws_instance" {
  description = "Path ssh key"
  default     = "ssh-gui" 
}