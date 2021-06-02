resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "for ALB"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group" "fargate" {
  name        = "fargate-sg"
  description = "for Fargate"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group" "mastodon_db" {
  name        = "mastodon_db"
  description = "for DB"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group" "mastodon_elasticache" {
  name        = "mastodon_elasticache"
  description = "for Elasticache"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "allow_http_for_alb" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow_http_for_alb"
}

resource "aws_security_group_rule" "allow_https_for_alb" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow_https_for_alb"
}

resource "aws_security_group_rule" "allow_streaming_for_alb" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 4000
  to_port           = 4000
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow_streaming_for_alb"
}

resource "aws_security_group_rule" "from_alb_to_fargate" {
  security_group_id        = aws_security_group.fargate.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 0
  to_port                  = 65535
  cidr_blocks              = ["0.0.0.0/0"]
  description              = "from_alb_to_fargate"
}

resource "aws_security_group_rule" "from_fargate_to_db" {
  security_group_id        = aws_security_group.mastodon_db.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.fargate.id
  description              = "from_fargate_to_db"
}

resource "aws_security_group_rule" "from_fargate_to_elasticache" {
  security_group_id        = aws_security_group.mastodon_elasticache.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 6379
  to_port                  = 6379
  source_security_group_id = aws_security_group.fargate.id
  description              = "from_fargate_to_elasticache"
}

resource "aws_security_group_rule" "egress_alb" {
  security_group_id = aws_security_group.alb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound ALL"
}

resource "aws_security_group_rule" "egress_fargate" {
  security_group_id = aws_security_group.fargate.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound ALL"
}

resource "aws_security_group_rule" "egress_db" {
  security_group_id = aws_security_group.mastodon_db.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound ALL"
}

resource "aws_security_group_rule" "egress_elasticache" {
  security_group_id = aws_security_group.mastodon_elasticache.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound ALL"
}