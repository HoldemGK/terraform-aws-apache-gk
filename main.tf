provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

module "apache" {
  source        = ".//terraform-aws-apache"
  instance_type = var.instance_type
  vpc_id        = var.vpc_id
  allow_ip      = var.allow_ip
  server_name   = var.server_name
  public_key    = var.public_key
}

output "public_ip" {
  value = module.apache.public_ip
}