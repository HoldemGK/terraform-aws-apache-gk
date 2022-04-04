Terraform module to provision EC2

Not intended for production use.

```hcl
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

module "apache" {
  source        = ".//terraform-aws-apache"
  instance_type = "t2.micro"
  vpc_id        = "vpc-0000000"
  allow_ip      = "MY_IP/24"
  server_name   = "AppServer"
  public_key    = "ssh-rsa AAAAMY_SSH_PUB_KEY"
}

output "public_ip" {
  value = module.apache.public_ip
}
```