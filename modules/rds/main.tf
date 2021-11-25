# Security group of the db
resource "aws_security_group" "rds-sg" {
  vpc_id            = var.vpc_id
  name              = "${var.prefix_name}-sg-database"
  description       = "security group for the database"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.webserver_sg_id
  }
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.packer_sg_id
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  tags = {
    Name = "${var.prefix_name}-sg-database"
  }
}

# Subnets of the db
resource "aws_db_subnet_group" "rds-subnet" {
  name        = "rds-subnet"
  description = "RDS subnet group"
  subnet_ids  = var.private_subnet_ids
  lifecycle {
    create_before_destroy = true
  }
}

# Parameters of the db (rds)
resource "aws_db_parameter_group" "rds-parameters" {
  name        = "rds-params"
  family      = "mariadb10.5"
  description = "rds parameter group"
  lifecycle {
    create_before_destroy = true
  }
}

# Db instance
resource "aws_db_instance" "rds" {
  allocated_storage         = var.storage_gb
  storage_type              = var.storage_type
  engine                    = "mariadb"
  engine_version            = var.rds_version
  instance_class            = var.rds_instance_type
  skip_final_snapshot       = true
  identifier                = "rds"
  name                      = var.db_name
  username                  = var.db_username
  password                  = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.rds-subnet.name
  parameter_group_name      = aws_db_parameter_group.rds-parameters.name
  multi_az                  = var.is_multi_az
  vpc_security_group_ids    = [aws_security_group.rds-sg.id]
  tags = {
    Name = "${var.prefix_name}-rds"
  }
}