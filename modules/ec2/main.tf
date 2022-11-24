#region Create a security group
  /**
    *  Docs
    * 'https://github.com/diogolimaelven/elvenworks_formacao_sre/blob/main/Aula_terraform/main.tf'
    * 'https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group'
    *
  **/
  resource "aws_security_group" "allow_traffic" {
    name        = var.name_security_group
    description = "Allow ssh and http inbound traffic"
    vpc_id      = var.vpc_id

    ingress {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
      Name = "allow_traffic"
    }
  }
#endregion

#region
  /**
  * Docs
  * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#security_groups
  * https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
  **/
  resource "aws_instance" "aws_ec2" {
    count = 2 //Create a two instances equals
  
    ami           = var.aim_aws_instance
    instance_type = var.instance_type_aws_instance
    monitoring                  = true
    associate_public_ip_address = true
    subnet_id              = var.subnet_id
    vpc_security_group_ids = [aws_security_group.allow_traffic.id]
    
    tags = {
      Name = "terraform_ec2-${count.index}"
    }
  }
#endregion