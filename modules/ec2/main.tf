#region Create a security group
  /**
    *  Docs
    * 'https://github.com/diogolimaelven/elvenworks_formacao_sre/blob/main/Aula_terraform/main.tf'
    * 'https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group'
    *
  **/
  resource "aws_security_group" "allow_traffic" {
    name        = var.name_security_group
    description = "Allow ssh, http, https and mysql inbound traffic"
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

    ingress {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "MYSQL/Aurora"
      from_port   = 3306
      to_port     = 3306
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

#region Create Ec2 Instances
  /**
    * Docs
    * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#security_groups
    * https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
    * https://developer.hashicorp.com/terraform/language/meta-arguments/count
    * https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource
    * https://developer.hashicorp.com/terraform/language/resources/provisioners/connection
    * https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec
    * https://developer.hashicorp.com/terraform/language/values/locals
    * https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu
  **/
  locals {
    subnet_ids = concat([var.public_subnet_id_a], [var.public_subnet_id_b])
  }
  resource "aws_instance" "aws_ec2" {
    count                       = var.count_instances # Create a number "var.count_instances" instances equals
  
    ami                         = var.aim_aws_instance
    instance_type               = var.instance_type_aws_instance
    monitoring                  = true
    associate_public_ip_address = true
    subnet_id                   = element(local.subnet_ids, count.index)
    vpc_security_group_ids      = [aws_security_group.allow_traffic.id]
    key_name                    = var.key_aws_instance
    
    # Bootstrap script can run on any instance of the aws_ec2
    # So we just choose the number instances
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.key_aws_instance}.pem")
      host        = self.public_ip
      timeout     = "5m"
    }

    # Execute commands remote in server(s) 
    provisioner "remote-exec" {
      inline = [
        "sudo apt-get update",
        "sudo apt-get install -y software-properties-common",
        "sudo apt-add-repository --yes --update ppa:ansible/ansible",
        "sudo apt install ansible -y",
        "mkdir -p /home/ubuntu/ansible",
        "sudo apt install curl unzip -y",
        "ansible-galaxy collection install community.grafana"
      ]
    }
    # Copies the file as the ubuntu user using SSH
    provisioner "file" {
      source      = var.source_ansible
      destination = var.dest_ansible
    }

    # Copies the file wp-config files as the ubuntu user using SSH
    provisioner "file" {
      source      = "${var.source_template_wp}/wp-config.php.tpl"
      destination = "${var.wp_files}/wp-config.php"
    }
   
    tags = {
      Name = "terraform_ec2-${count.index}"
    }
  }
#endregion