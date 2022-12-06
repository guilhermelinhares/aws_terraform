#region - Subnet RDS group
    /**
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_subnet_group
    */
    resource "aws_db_subnet_group" "rds_sub_groups" {
        name            = "sub_gp_rds"
        subnet_ids      = var.subnet_ids

        tags = {
            Name        = "Main DB Private Sub AZ-A+B"
            Environment = "developer"
        }
    }
#endregion

#region - Create a Random Password 
    /**
     * https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
    */
    resource "random_password" "password" {
        length           = 16
        special          = true
        override_special = "!#$%&*()-_=+[]{}<>:?"
    }
#endregion

#region - Create a RDS Instance
    /**
     *  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#multi_az
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
        vpc_security_group_ids  = [var.aws_security_group_rds]
        db_subnet_group_name    = aws_db_subnet_group.rds_sub_groups.id

        tags = {
           Name                = "RDS"
           Environment          = "developer"
        }
    }
#endregion

#region - Update environments in Localfiles
    /**
     * https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
     * https://developer.hashicorp.com/terraform/language/functions/templatefile
    */
    resource "local_file" "wp_config" {
        filename    = "${path.module}/templates/wp-config.php.tpl"
        content     = templatefile(
            "${path.module}/templates/wp-config.php.tpl",
            {
                db_name         = var.db_name,
                db_user         = var.db_user,
                db_password     = random_password.password.result
                db_host         = aws_db_instance.rds_db.address
            }
        )
    }
#endregion