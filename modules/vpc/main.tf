#region - Create a VPC
/**
  * Doc -> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
**/
  resource "aws_vpc" "main" {
    cidr_block       = var.vpc_main_cidr
    instance_tenancy = "default"

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
  * Doc -> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association
  */
  resource "aws_main_route_table_association" "public" {
    vpc_id         = aws_vpc.main.id
    route_table_id = aws_route_table.public.id
  }
#endregion

#region Create a routes tables public and private
  /**
  * Doc -> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
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
    * Doc -> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
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