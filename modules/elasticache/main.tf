#region - Create a Subnet Group Elasticache
    /**
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster
    */
    resource "aws_elasticache_subnet_group" "elasticache_sbg" {
        name                        = "my-cache-subnet"
        subnet_ids                  = ["${var.private_subnet_id_a}","${var.private_subnet_id_b}"]
    }
#endregion

#region Create a Cluster Elasticache
    /**
     * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster
     * https://aws.amazon.com/blogs/database/managing-amazon-elasticache-with-terraform/
    */
    resource "aws_elasticache_cluster" "aws_elasticache" {
        # count                   = var.count_instances
        cluster_id              = var.cluster_name
        # Note that ElastiCache for Outposts only supports `single-outpost` currently
        # outpost_mode          = "single-outpost"
        # preferred_outpost_arn = data.aws_outposts_outpost.example.arn
        engine                  = var.engine
        # Note that ElastiCache for Outposts only supports M5 and R5 node families currently
        node_type               = var.node_type_aws_elasticache
        num_cache_nodes         = var.number_cnodes
        parameter_group_name    = var.param_g_name
        port                    = var.elasticache_port
        subnet_group_name       = aws_elasticache_subnet_group.elasticache_sbg.name
        az_mode                 = var.multi_az

        tags = {
            Name                = "Elasticache"
            Environment         = "developer"
        }
    }
#endregion

#region - Edit a php.ini file with a address memcached

    resource "local_file" "php_ini" {
        filename    = "${path.module}/templates/php.ini.tpl"
        content     = templatefile(
            "${path.module}/templates/php.ini.tpl",
            {
                engine              =  var.engine,
                endpoint            =  aws_elasticache_cluster.aws_elasticache.cluster_address
                elasticache_port    =  var.elasticache_port
            }
        )
    }
#endregion