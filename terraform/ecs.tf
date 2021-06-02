resource "aws_ecr_repository" "mastodon" {
  name = "mastodon"
}

resource "aws_ecs_cluster" "cluster" {
  name = "cluster-mastodon"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}