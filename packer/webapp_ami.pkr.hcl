packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/amazon"
    }
  }
}
variable "access_key"{}
variable "secret_key"{}
variable "token"{}
variable "region"{}

source "amazon-ebs" "webapp"{
    access_key    = "${var.access_key}"
    secret_key    = "${var.secret_key}"
    token         = "${var.token}"
    region        = "${var.region}"
    source_ami    = "ami-01cc34ab2709337aa"
    ami_name      = "webappImage"
    ssh_username  = "ec2-user"
    instance_type = "t2.micro"
    force_delete_snapshot = true
    vpc_filter {
      filters = {
        "tag:Name": "pe-vpc"
    }
  }
    subnet_filter {
    filters = {
          "tag:Name": "pe-public-*"
    }
    most_free = true
    random = false
  }
    security_group_filter  {
    filters = {
          "tag:Name": "pe-sg-packer"
    }
  }

}

build {
    sources = [
        "source.amazon-ebs.webapp"
    ]
    provisioner "ansible" {
      playbook_file = "ansible/runsetup.yml"
    }
}