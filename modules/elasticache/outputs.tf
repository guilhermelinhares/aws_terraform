output "endpoint" {
  description   = "Enpoint name Memcached"
  value         = aws_elasticache_cluster.aws_elasticache.cluster_address
}