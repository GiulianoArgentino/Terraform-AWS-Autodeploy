
variable "vpc_id" {}

variable "private_subnet_ids" {
  type = list
}

variable "public_subnet_ids" {
  type = list
}

variable "webserver_port" {
	default = 80
}

variable "webserver_protocol" {
	default = "HTTP"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "min_instance" {
  description = "minimum number of instances for your ASG"
  default     = 1
}

variable "desired_instance" {
  description = "starting number of instances for your ASG"
  default     = 3
}

variable "max_instance" {
  description = "maximum number of instances for your ASG"
  default     = 3
}

variable "ami" {}

variable "ssh_key_dir" {
  description = "relative or absolute path to the ssh-key directory"
}
variable "prefix_name" {}
