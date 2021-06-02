resource "aws_elasticache_parameter_group" "mastodon" {
  name   = "mastodon"
  family = "redis5.0"

  parameter {
    name  = "cluster-enabled"
    value = "no"
  }
}

resource "aws_elasticache_subnet_group" "mastodon" {
  name = "mastodon"

  subnet_ids = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1c.id
  ]
}

resource "aws_elasticache_replication_group" "mastodon" {
  replication_group_id          = "mastodon"
  replication_group_description = "Cluster Disabled"
  engine                        = "redis"
  engine_version                = "5.0.4"
  number_cache_clusters         = 3
  node_type                     = "cache.m3.medium"
  snapshot_window               = "09:10-10:10"
  snapshot_retention_limit      = 7
  maintenance_window            = "mon:10:40-mon:11:40"
  automatic_failover_enabled    = true
  port                          = 6379
  apply_immediately             = false
  security_group_ids            = [aws_security_group.mastodon_elasticache.id]
  parameter_group_name          = aws_elasticache_parameter_group.mastodon.name
  subnet_group_name             = aws_elasticache_subnet_group.mastodon.name
}