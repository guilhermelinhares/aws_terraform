#region Create a EFS File System
  /**
   * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system
  */
  resource "aws_efs_file_system" "aws_efs" {
    creation_token      = var.token
    encrypted           = false
    performance_mode    = var.p_mode
    throughput_mode     = var.th_mode
    
    tags = {
      Name              = var.name_efs
      Environment       = "Developer"
    }
  }
#endregion

#region - Create EFS Policy
  /**
   * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_backup_policy
  */
  resource "aws_efs_backup_policy" "policy" {
    file_system_id = aws_efs_file_system.aws_efs.id

    backup_policy {
      status = "DISABLED"
    }
  }
#endregion

#region - Create EFS Mount Target
    /**
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target
    */
    resource "aws_efs_mount_target" "efs_mtarget_a" {
     file_system_id         = aws_efs_file_system.aws_efs.id
     subnet_id              = var.private_subnet_id_a
     security_groups        = [var.aws_security_group_efs]
    }   
    resource "aws_efs_mount_target" "efs_mtarget_b" {
     file_system_id         = aws_efs_file_system.aws_efs.id
     subnet_id              = var.private_subnet_id_b
     security_groups        = [var.aws_security_group_efs]
    }   
#endregion