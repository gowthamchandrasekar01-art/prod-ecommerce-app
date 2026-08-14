resource "aws_db_subnet_group" "prod_ecommerce" {
  name        = "prod-ecommerce-db-subnet-group"
  description = "Private database subnet group for production e-commerce application"

  subnet_ids = [
    aws_subnet.db_a.id,
    aws_subnet.db_b.id
  ]
}
resource "aws_db_instance" "prod_ecommerce" {
  identifier = "prod-ecommerce-db"

  engine         = "mysql"
  engine_version = "8.4.9"
  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 1000
  storage_type          = "gp3"
  storage_encrypted     = true
  kms_key_id            = "arn:aws:kms:ap-south-1:809311528378:key/e736400d-913b-460f-99f2-5cc7ba452fd9"

  multi_az            = true
  publicly_accessible = false

  port = 3306

  db_subnet_group_name   = aws_db_subnet_group.prod_ecommerce.name
  vpc_security_group_ids = [aws_security_group.db.id]

  backup_retention_period = 7

  monitoring_interval = 60

  auto_minor_version_upgrade = true
  deletion_protection        = false
  copy_tags_to_snapshot      = true
  skip_final_snapshot        = true
  apply_immediately          = false

  parameter_group_name = "default.mysql8.4"
  option_group_name    = "default:mysql-8-4"

  lifecycle {
    ignore_changes = [
      password,
      username,
    ]
  }
}
