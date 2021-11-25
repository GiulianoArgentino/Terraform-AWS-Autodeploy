variable "prefix_name" {}

variable "vpc_id" {}

variable "private_subnet_ids" {
	type = list
}

variable "webserver_sg_id" {
  type        = list
  description = "security group id of the webserver" 
}

variable "packer_sg_id" {
  type        = list
  description = "security group id of Packer" 
}

variable "storage_gb" {
	description = "how much storage space do you want to allocate?"
  	default     = 1
}

variable "rds_version" {
	default = "10.5.12"
}

variable "rds_instance_type" {
	description = "use micro if you want to use the free tier"
	default     = "db.t2.micro"
}

variable "db_name" {
	description = "database name"
}

variable "db_username" {
	description = "database username"
	default     = "root"
}

variable "db_password" {
	description = "database user password"
}

variable "is_multi_az" {
	description = "set to true to have high availability"
	default = false
}

variable "storage_type" {
	description = "Storage type used for the database"
	default = "gp2"
}


variable "backup_retention_period" {
	description = "how long you’re going to keep your backups (30 max) ?"
	default     = 1
}