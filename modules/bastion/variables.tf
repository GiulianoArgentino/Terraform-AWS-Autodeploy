variable "ssh_sg_id" {
  type        = list
  description = "security group id of the SSH sg" 
}
variable "public_subnet_ids" {}
variable "ssh_key_dir" {
  description = "relative or absolute path to the ssh-key directory"
}
variable "prefix_name" {}

// Create aws_ami filter to pick up the ami available in your region
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}