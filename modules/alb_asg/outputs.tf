output "alb_dns_name" {
  value     = aws_lb.my-alb.dns_name
  sensitive = true
}

output "webserver_sg_id" {
  value = [aws_security_group.sg-instances.id]
  sensitive = true
}
output "ssh_sg_id" {
  value = [aws_security_group.sg-ssh.id]
  sensitive = true
}
output "asg_name" {
  value = aws_autoscaling_group.my-autoscaling.name
  sensitive = true
}