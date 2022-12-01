#region Create Ec2 Instances
  /**
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
    vpc_security_group_ids      = [var.aws_security_group_ec2]
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
        "sudo apt update -y",
        "sudo apt-get install -y software-properties-common",
        "sudo apt-add-repository --yes --update ppa:ansible/ansible",
        "sudo apt install ansible -y",
        "mkdir -p /home/ubuntu/ansible",
        "sudo mkdir /data_efs",
        "sudo apt install curl unzip nfs-common -y",
        "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${var.dns_efs}:/ /data_efs"
      ]
    }
    
    # Copies the file as the ubuntu user using SSH
    provisioner "file" {
      source      = var.source_ansible
      destination = var.dest_ansible
    }

    # Copies the file wp-config as the ubuntu user using SSH
    provisioner "file" {
      source      = "${var.source_template_wp}/wp-config.php.tpl"
      destination = "${var.wp_files}/wp-config.php"
    }

    # Copies the file php.ini as the ubuntu user using SSH
    provisioner "file" {
      source      = "${var.source_template_elasticache}/php.ini.tpl"
      destination = "${var.php_files}/php.ini"
    }

    provisioner "remote-exec" {
      inline = [
        "ansible-galaxy collection install community.grafana",
        "ansible-galaxy collection install community.crypto",
        "cd /home/ubuntu/ansible/ && ansible-playbook main.yaml"
      ]
    }

    tags = {
      Name = "terraform_ec2-${count.index}"
    }
  }
#endregion