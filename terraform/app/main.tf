terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

module "keypair" {
  source   = "../modules/keypair"
  key_name = var.key_name
}

module "security_group" {
  source        = "../modules/security_group"
  name          = "${var.project_name}-sg"
  vpc_id        = data.aws_vpc.default.id
  allowed_cidrs = var.allowed_cidrs
}

module "ec2" {
  source             = "../modules/ec2"
  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = var.instance_type
  key_name           = module.keypair.key_name
  subnet_id          = data.aws_subnets.default.ids[0]
  security_group_ids = [module.security_group.security_group_id]
  name               = "${var.project_name}-jenkins"
  volume_size        = var.root_volume_size
}

module "ebs" {
  source            = "../modules/ebs"
  availability_zone = module.ec2.availability_zone
  size              = var.ebs_size
  name              = "${var.project_name}-data"
  instance_id       = module.ec2.instance_id
}

module "eip" {
  source      = "../modules/eip"
  instance_id = module.ec2.instance_id
  name        = "${var.project_name}-eip"
}

resource "local_file" "jenkins_ec2" {
  filename = "${path.module}/jenkins_ec2.txt"
  content  = <<-EOT
    public_ip=${module.eip.public_ip}
    instance_id=${module.ec2.instance_id}
    jenkins_url=http://${module.eip.public_ip}:8080
  EOT
}
