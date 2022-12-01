#region - Load Balancer
  #region - Create Load Balancer -> Basic configuration + Mapping
    /**
      * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#network-load-balancer
      * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb
    */
    resource "aws_lb" "load_balancer" {
      name               = var.name_lb
      load_balancer_type = var.lb_type
      internal           = true
      # security_groups    = [aws_security_group.lb_sg.id]

      subnet_mapping {
        subnet_id            = var.public_subnet_id_a
        private_ipv4_address = var.ipv4_public_cidr_a
      }

      subnet_mapping {
        subnet_id            = var.public_subnet_id_b
        private_ipv4_address = var.ipv4_public_cidr_b
      }

      tags = {
        Environment = "lb_dev"
      }
    }
  #endregion

  #region - Create a Listeners

  resource "aws_lb_listener" "listener_http" {
    load_balancer_arn = aws_lb.load_balancer.arn
    port              = "80"
    protocol          = "TCP"

    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.tg_group_http.arn
    }
  }

  resource "aws_lb_listener" "listener_https" {
    load_balancer_arn = aws_lb.load_balancer.arn
    port              = "443"
    protocol          = "TCP"

    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.tg_group_https.arn
    }
  }
  #endregion

  #region - Create targets Groups
    /**
      * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
    */
    resource "aws_lb_target_group" "tg_group_http" {
      name         = var.aws-lb-tg-http
      port         = 80
      protocol     = "TCP"
      vpc_id       = var.vpc_id

      health_check {
        enabled = true  
        protocol   = "HTTP"
        path       =  "/info.php"
      }
    }
    resource "aws_lb_target_group" "tg_group_https" {
      name         = var.aws-lb-tg-https
      port         = 443
      protocol     = "TCP"
      vpc_id       = var.vpc_id

      health_check {
        enabled = true  
        protocol   = "HTTP"
        path       =  "/info.php"
      }
    }
  #endregion
#endregion

#region - EC2
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
          "ansible-galaxy collection install community.crypto",
          "ansible-galaxy collection install community.grafana",
          "cd /home/ubuntu/ansible/ && ansible-playbook main.yaml"
        ]
      }

      tags = {
        Name = "terraform_ec2-${count.index}"
      }
    }
  #endregion
#endregion

#region - Launch Template + Auto-Scaling + Images
  #region - Atach resources in target group 
    /**
      * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
      * https://stackoverflow.com/questions/44491994/not-able-to-add-multiple-target-id-inside-targer-group-using-terraform
    */
    resource "aws_lb_target_group_attachment" "tg_group_attach_http" {

      count            = length(aws_instance.aws_ec2)
      target_group_arn = aws_lb_target_group.tg_group_http.arn
      target_id        = aws_instance.aws_ec2[count.index].id
      port             = 80
    }
    resource "aws_lb_target_group_attachment" "tg_group_attach_https" {
      count            = length(aws_instance.aws_ec2)
      target_group_arn = aws_lb_target_group.tg_group_https.arn
      target_id        = aws_instance.aws_ec2[count.index].id
      port             = 443
    }
  #endregion

  #region - Create a Image from EC2
    /**
      * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ami_from_instance
      * https://www.tinfoilcipher.co.uk/2020/10/19/terraform-tricks-working-with-timestamps/
    */
    locals {
      timestamp                 = timestamp()
      current_day               = formatdate("YYYY-MM-DD", local.timestamp)
    }
    resource "aws_ami_from_instance" "aws_ec2_ami" {
      name                      = "ec2-template-${local.current_day}"
      source_instance_id        = aws_instance.aws_ec2.*.id[0]
      snapshot_without_reboot   = false
    }  
  #endregion

  #region - Create a Launch Template
    /**
    * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
    */
    
    resource "aws_launch_template" "launch_tpl" {
      name                    = var.name_launch_tpl
      image_id                = aws_ami_from_instance.aws_ec2_ami.id
      instance_type           = var.instance_type_aws_instance
      key_name                = var.key_aws_instance
      vpc_security_group_ids  = [var.aws_security_group_ec2]

    }
  #endregion

  #region - Create a Auto-Scaling Group
    /**
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
    */
    resource "aws_autoscaling_group" "aws_asg" {
      name                    = var.name_asg
      vpc_zone_identifier     = ["${var.private_subnet_id_a}","${var.private_subnet_id_b}"]
      target_group_arns       = ["${aws_lb_target_group.tg_group_http.id}","${aws_lb_target_group.tg_group_https.id}"]
      desired_capacity        = 2
      max_size                = 4
      min_size                = 2

      launch_template {
        id          = aws_launch_template.launch_tpl.id
        version     = "$Latest"
      }

    }
  #endregion

  #region - Create a Auto-Scaling Policy
    /**
     *https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy
    */    
    resource "aws_autoscaling_policy" "aws_asg_policy" {
      name                   = "Target Tracking Policy"
      
      adjustment_type        = "ChangeInCapacity"
      autoscaling_group_name = aws_autoscaling_group.aws_asg.name
      policy_type            = "TargetTrackingScaling"

      target_tracking_configuration {
        predefined_metric_specification {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 70
      }
    }

  #endregion

  #region - Create a Tag Auto-Scaling
    /**
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group_tag
    */
    resource "aws_autoscaling_group_tag" "aws_ags_tags" {

      autoscaling_group_name  = aws_autoscaling_group.aws_asg.name

      tag {

        key   = "Name"
        value = "aws_ags_ec2"

        propagate_at_launch = true
      }
    }

  #endregion

#endregion