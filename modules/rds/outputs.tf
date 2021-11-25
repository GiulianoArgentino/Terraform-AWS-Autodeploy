
output "db_endpoint" {
  value = aws_db_instance.rds.endpoint
  sensitive = true
}

output "db_address" {
  value = aws_db_instance.rds.address
  sensitive = true
}

output "db_port" {
  value = aws_db_instance.rds.port
  sensitive = true
}


