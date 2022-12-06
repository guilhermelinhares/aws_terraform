# Aws Terraform + Ansible

A simple automated Wordpress blog with terraform and ansible.

## Description

The proposite project is create a multiple services in aws with terraform for a simple blog in Wordpress, with as services:

### Terraform:

* VPC 
* Security Groups
* Load Balancer
* Auto-Scaling 
* Lanch Template
* RDS + Generate a random database password
* EC2 with Mult-AZ
* Elasticache with a Memcached 
* EFS

### Ansible:

* Wordpress
* Php
* Nginx
* Openssl Self Signed (Just Labs)
* Prometheus + Template
* Grafana

## Getting Started

### Dependencies

* Terraform.
* AWS CLI
* Account Valid Aws

### Installing

* [Link](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) install terraform pack
* [Link](https://aws.amazon.com/pt/cli/) install aws cli
* [Link](https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all) Aws valid account

### Configure AWS IAM Account

With account created and validate, is recommended create a new user in IAM Service, with any name you wanted and any rules you
need, after create a new user is generate
a acess key id, acess key secret and password, save in a security place.

### Configure AWS CLI

Before begin initialize a terraform provisioner you need configure in your sistem operation terminal service with this command.

```
aws configure
```

### Executing Terraform 

* Initialize terraform service

```
terraform init
```
* Generate a plan of terraform

```
terraform plan
```

* Apply all services in your aws account

```
terraform apply
```
