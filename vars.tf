#GLOBAL
variable "region" {
  default = "us-east-1"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_session_token" {}

variable "prefix_name" {
  default = "pe"
}

#S3
variable "bucket_name" {
  default = "pe-bucket"
}

#ALB_ASG
variable "ssh_key_dir" {
  default = "$HOME/.ssh"
}

#AMI
data "aws_ami" "amazon-linux-2-custom" {
  depends_on       = [module.my_ami]
  owners           = ["self"]
  most_recent      = true

  filter {
    name   = "name"
    values = ["webappImage"]
  }
}

#RDS
variable "db_name" {
  default = "employees"
}
variable "db_user" {}

variable "db_password" {}