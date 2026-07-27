resource "aws_db_instance" "private_RDS" {
  identifier     = "app-data"
  instance_class = "db.t3.micro"
  # 5GiB
  allocated_storage = 5

  engine         = "postgres"
  engine_version = "18.3"

  username = "me"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.RDS_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  parameter_group_name = aws_db_parameter_group.RDS_PostgreSQL.name

  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 5

  tags = {
    Terraform = "true"
  }
}

/* Used to set PostgreSQL configurations
    - version #18
    - Shared buffer: 25% of instance memory
    - Cache: 75% of instance memory
*/
resource "aws_db_parameter_group" "RDS_PostgreSQL" {
  name   = "rds-parameter-group"
  family = "postgres18"

  parameter {
    name         = "shared_buffers"
    value        = "{DBInstanceClassMemory/4}" # 25% of instance memory
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "effective_cache_size"
    value        = "{DBInstanceClassMemory*3/4}" # 75% of instance memory
    apply_method = "pending-reboot"
  }
}

/*
Notes: 
 - Highest privileged role for PostgreSQL: rds_superuser role
    - rds_superuser role documentation: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.Roles.html

 - PostgreSQL logs doc: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_LogAccess.Concepts.PostgreSQL.html
    - Stored on RDS instance
    - Captures: login failures, fatal server errors, "deadlocks", query failures
    - Often paired with CloudWatch to store log records, view metrics, create alarms

*/