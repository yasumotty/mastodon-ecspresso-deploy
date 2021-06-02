resource "aws_db_parameter_group" "mastodon" {
  name   = "mastodon"
  family = "postgres12"
}

resource "aws_db_subnet_group" "mastodon" {
  name        = "mastodon"
  description = "mastodon"

  subnet_ids = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1c.id
  ]
}

resource "aws_db_instance" "mastodon" {
  allocated_storage          = 20
  auto_minor_version_upgrade = true
  backup_retention_period    = 7
  backup_window              = "20:00-21:00"
  db_subnet_group_name       = aws_db_subnet_group.mastodon.name
  engine                     = "postgres"
  engine_version             = "12.3"
  identifier                 = "mastodon"
  instance_class             = "db.t3.small"
  multi_az                   = true
  name                       = "mastodon"
  parameter_group_name       = aws_db_parameter_group.mastodon.name
  password                   = "postgres"
  skip_final_snapshot        = true
  username                   = "postgres"

  vpc_security_group_ids = [
    aws_security_group.mastodon_db.id
  ]
}