#region - Create a VPC
/**
  * Doc -> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
**/
  resource "aws_vpc" "main" {
    cidr_block            = var.vpc_main_cidr
    instance_tenancy      = "default"
    enable_dns_hostnames  = true # flag to enable/disable
    tags = {
      Name = "main"
    }
  }
#endregion

#region - Create Subnet Public and Private
  /**
    * Doc -> #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
    *
  */
  resource "aws_subnet" "main_public_subnet_a" {
    vpc_id                    = aws_vpc.main.id
    cidr_block                = var.vpc_main_public_cidr_a
    map_public_ip_on_launch   = true #Specify with you instance is public or not;
    availability_zone         = "${var.region}a"

    tags = {
      Name                    = "Main-Public-AZ-A"
    }
  }
  resource "aws_subnet" "main_public_subnet_b" {
    vpc_id                    = aws_vpc.main.id
    cidr_block                = var.vpc_main_public_cidr_b
    map_public_ip_on_launch   = true #Specify with you instance is public or not;
    availability_zone         = "${var.region}b"

    tags = {
      Name = "Main-Public-AZ-B"
    }
  }
  resource "aws_subnet" "main_private_subnet_a" {
    vpc_id                    = aws_vpc.main.id
    cidr_block                = var.vpc_main_private_cidr_a
    map_public_ip_on_launch   = false
    availability_zone         = "${var.region}a"

    tags = {
      Name = "Main-Private-AZ-A"
    }
  }
  resource "aws_subnet" "main_private_subnet_b" {
    vpc_id                    = aws_vpc.main.id
    cidr_block                = var.vpc_main_private_cidr_b
    map_public_ip_on_launch   = false
    availability_zone         = "${var.region}b"

    tags = {
      Name = "Main-Private-AZ-B"
    }
  }
#endregion

#region Create a Internet Gateway
/**
* Doc -> #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
*/
  resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
    tags = {
      Name = "NatGW-Main"
    }
  }
#endregion

#region Create a main route and associate with a vpc 
  /**
   *  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association
  */
  resource "aws_main_route_table_association" "public" {
    vpc_id         = aws_vpc.main.id
    route_table_id = aws_route_table.public.id
  }
#endregion

#region Create a routes tables public and private
  /**
   * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
  */
  resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
      Name = "Public"
    }
  }
  resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route = []

    tags = {
      Name = "Private"
    }
  }
#endregion

#region Association subnets in route tables
  /**
    * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
  */
  resource "aws_route_table_association" "public_a" {
    route_table_id = aws_route_table.public.id
    subnet_id      = aws_subnet.main_public_subnet_a.id
  }
  resource "aws_route_table_association" "public_b" {
    route_table_id = aws_route_table.public.id
    subnet_id      = aws_subnet.main_public_subnet_b.id
  }
  resource "aws_route_table_association" "private_a" {
    route_table_id = aws_route_table.private.id
    subnet_id      = aws_subnet.main_private_subnet_a.id
  }
  resource "aws_route_table_association" "private_b" {
    route_table_id = aws_route_table.private.id
    subnet_id      = aws_subnet.main_private_subnet_b.id
  }
#endregion

#region Create a security group Ec2
  /**
    * 'https://github.com/diogolimaelven/elvenworks_formacao_sre/blob/main/Aula_terraform/main.tf'
    * 'https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group'
    *
  **/
  resource "aws_security_group" "aws_security_group_ec2" {
    name        = var.name_security_group_ec2
    description = "Allow ssh, http, https and mysql inbound traffic"
    vpc_id      = aws_vpc.main.id

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

    ingress {
      description = "Prometheus"
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "Prometheus Node Exporter"
      from_port   = 9100
      to_port     = 9100
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "Alert Manager"
      from_port   = 9093
      to_port     = 9093
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "Grafana"
      from_port   = 3000
      to_port     = 3000
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
      Name = "aws_security_group_ec2"
    }
  }
#endregion

#region - Create a security group RDS
    /**
     * 'https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group'
    */
    resource "aws_security_group" "aws_security_group_rds" {
      name        = var.name_security_group_rds
      description = "Allow port db inbound traffic"
      vpc_id      = aws_vpc.main.id

      ingress {
        description     = "RDS Ec2"
        from_port       = var.rds_port
        to_port         = var.rds_port
        protocol        = "tcp"
        security_groups = [aws_security_group.aws_security_group_ec2.id]
      }

      egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }

      tags = {
          Name = "aws_security_group_rds"
      }
    }
#endregion

#region - Create a Security Group Elasticache
  /**
    * https://registry.terraform.io/modules/cloudposse/elasticache-memcached/aws/latest
    * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster
  */
  resource "aws_security_group" "aws_security_group_sections" {
    name        = var.name_security_group_sections
    description = "Allow memcached for Ec2 SGA inbound traffic"
    vpc_id      = aws_vpc.main.id

    ingress {
      description = "Memcached"
      from_port   = 11211
      to_port     = 11211
      protocol    = "tcp"
      security_groups = [aws_security_group.aws_security_group_ec2.id]
    }

    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
      Name = "aws_security_group_sections"
    }
  }
#endregion

#region - Create a Security Group EFS
  /**
   * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system
   * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/efs_file_system
   * https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest
  */
  resource "aws_security_group" "aws_security_group_efs" {
    name        = var.name_security_group_efs
    description = "Allow efs for Ec2 SGA inbound traffic"
    vpc_id      = aws_vpc.main.id

    ingress {
      description = "EFS - All protocols"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      security_groups = [aws_security_group.aws_security_group_ec2.id]
    }

    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
      Name = "aws_security_group_sections"
    }
  }
#endregion