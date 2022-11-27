#region - Create a security group
    /**
    * Doc     
    * 'https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group'
    */
    resource "aws_security_group" "allow_traffic_sg" {
        name        = var.name_security_group
        description = "Allow port db inbound traffic"
        vpc_id      = var.vpc_id

        ingress {
            description     = "RDS Ec2"
            from_port       = var.rds_port
            to_port         = var.rds_port
            protocol        = "tcp"
            security_groups = [var.ec2_security_group_id]
        }

        egress {
            from_port        = 0
            to_port          = 0
            protocol         = "-1"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
        }

        tags = {
            Name = "allow_traffic_rds"
        }
    }
#endregion

#region - Subnet RDS group
    /**
    * Doc
    * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
    * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_subnet_group
    */
    resource "aws_db_subnet_group" "rds_sub_groups" {
        name       = "sub_gp_rds"
        subnet_ids = var.subnet_ids

        tags = {
          Name = "Main DB Private Sub AZ-A+B"
        }
    }
#endregion

#region - Create a Random Password 
    /**
    * Doc https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
    */
    resource "random_password" "password" {
        length           = 16
        special          = true
        override_special = "!#$%&*()-_=+[]{}<>:?"
    }
#endregion

#region - Create a RDS Instance
    /**
    * Doc https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#multi_az
    */
    resource "aws_db_instance" "rds_db" {
        identifier              = var.rds_instance_identifier
        instance_class          = var.instance_type_aws_db_instance
        allocated_storage       = var.allocated_storage
        max_allocated_storage   = 0 // 0 to disable autoscaling
        engine                  = var.db_engine_type
        db_name                 = var.db_name
        username                = var.db_user
        password                = random_password.password.result
        storage_type            = var.storage_type
        multi_az                = true 
        skip_final_snapshot     = true
        engine_version          = var.db_engine_version
        publicly_accessible     = false
        port                    = var.rds_port
        vpc_security_group_ids  = [aws_security_group.allow_traffic_sg.id]
        db_subnet_group_name    = aws_db_subnet_group.rds_sub_groups.id
    }
#endregion