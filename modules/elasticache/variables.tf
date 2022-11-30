variable "cluster_name" {
  description   = "Name of cluster"
  default       = "cluster-aws-cache"
}

variable "multi_az" {
  description = "single-az || cross-az"
  default     = "cross-az" 
}

variable "number_cnodes" {
  description   = "The number of nodes in this cache cluster. A node is a partition of your data."
  default       = 2
}

variable "private_subnet_id_a" {
  description   = "Private Subnet AZ-A"
}

variable "private_subnet_id_b" {
  description   = "Private Subnet AZ-B"
}

variable "node_type_aws_elasticache" {
  description   = "Instance T3 Micro"
  default       = "cache.t3.micro"
}

variable "engine" {
  description   = "Type of Cluster Elasticache Memcached || Redis"
  default       =  "memcached"
}

variable "elasticache_port" {
  description   = "Port of Elasticache Cluster"
  default       =  11211
}

variable "param_g_name" {
  description   = "Parameter groups control the runtime properties of your nodes and clusters."
  default       =  "default.memcached1.6"
}
