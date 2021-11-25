output "vpc_id" {
  value = aws_vpc.main.id
  sensitive = true
}

output "private_subnet_ids" {
  value = [for private_subnet in aws_subnet.main-private : private_subnet.id]
  sensitive = true
}

output "public_subnet_ids" {
  value = [for public_subnet in aws_subnet.main-public : public_subnet.id]
  sensitive = true
}

output "packer_sg_id" {
  value = [aws_security_group.sg-packer.id]
  sensitive = true
}