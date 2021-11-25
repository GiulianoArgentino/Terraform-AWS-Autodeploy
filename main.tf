provider "aws" {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token = var.aws_session_token
}
module "my_vpc" {
    source                  = "./modules/vpc"
    vpc_cidr                = "10.0.0.0/16"
    public_subnets_cidr     = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets_cidr    = ["10.0.3.0/24", "10.0.4.0/24"]
    azs                     = ["us-east-1a", "us-east-1b"]
    prefix_name             = var.prefix_name
}

module "my_s3" {
    source                  = "./modules/s3"
    bucket_name             = var.bucket_name
    prefix_name             = var.prefix_name
}

module "my_ami" {
  depends_on = [module.my_rds,module.my_vpc]
  source                    = "./modules/ami"
}
module "my_alb_asg" {
    source               = "./modules/alb_asg"
    webserver_port       = 80
    webserver_protocol   = "HTTP"
    instance_type        = "t2.micro"
    private_subnet_ids   = module.my_vpc.private_subnet_ids
    public_subnet_ids    = module.my_vpc.public_subnet_ids
    min_instance         = 2
    desired_instance     = 2
    max_instance         = 3
    ami                  = data.aws_ami.amazon-linux-2-custom.id
    ssh_key_dir          = var.ssh_key_dir
    vpc_id               = module.my_vpc.vpc_id
    prefix_name          = var.prefix_name
}

module "my_bastion" {
  source                 = "./modules/bastion"
  public_subnet_ids      = module.my_vpc.public_subnet_ids
  ssh_sg_id              = module.my_alb_asg.ssh_sg_id
  ssh_key_dir            = var.ssh_key_dir
  prefix_name            = var.prefix_name
}

module "my_cloudwatch_cpu_alarm" {
  source                 = "./modules/cloudwatch"
  min_cpu_percent_alarm  = 5
  max_cpu_percent_alarm  = 80
  asg_name               = module.my_alb_asg.asg_name
  prefix_name            = var.prefix_name
}

module "my_rds" {
  source                   = "./modules/rds"
  webserver_sg_id          = module.my_alb_asg.webserver_sg_id
  packer_sg_id             = module.my_vpc.packer_sg_id
  private_subnet_ids       = module.my_vpc.private_subnet_ids
  storage_gb               = 5
  vpc_id                   = module.my_vpc.vpc_id
  rds_version              = "10.5.12"
  rds_instance_type        = "db.t2.micro"
  db_name                  = var.db_name
  db_username              = var.db_user
  db_password              = var.db_password
  is_multi_az              = false
  storage_type             = "gp2"
  backup_retention_period  = 1
  prefix_name              = var.prefix_name
}

module "my_secrets" {
  source                   = "./modules/secrets"
  depends_on               = [ module.my_rds ]
  aws_access_key           = var.aws_access_key
  aws_secret_key           = var.aws_secret_key
  aws_session_token        = var.aws_session_token
  aws_region               = var.region
  aws_s3_bucket            = var.bucket_name
  dbaddress                = module.my_rds.db_address
  dbport                   = module.my_rds.db_port
  dbuser                   = var.db_user
  dbpassword               = var.db_password
}
