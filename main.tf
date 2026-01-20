terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "rgtrovao-terraform-bucket"
    key    = "rgtrovao/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# Módulo VPC
module "vpc" {
  source = "./modules/vpc"

  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  enable_nat_gateway   = var.enable_nat_gateway

  tags = var.tags
}

# Módulo Internet Gateway
module "internet_gateway" {
  source = "./modules/internet_gateway"

  vpc_id   = module.vpc.vpc_id
  vpc_name = var.vpc_name

  tags = var.tags
}

# Módulo Subnets
module "subnets" {
  source = "./modules/subnets"

  vpc_id   = module.vpc.vpc_id
  vpc_name = var.vpc_name

  availability_zones = var.availability_zones

  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs

  internet_gateway_id = module.internet_gateway.internet_gateway_id
  enable_nat_gateway  = var.enable_nat_gateway

  tags = var.tags
}

# Módulo Route Tables
module "route_tables" {
  source = "./modules/route_tables"

  vpc_id              = module.vpc.vpc_id
  vpc_name            = var.vpc_name
  internet_gateway_id = module.internet_gateway.internet_gateway_id

  public_subnet_ids   = module.subnets.public_subnet_ids
  private_subnet_ids  = module.subnets.private_subnet_ids
  database_subnet_ids = module.subnets.database_subnet_ids

  enable_nat_gateway = var.enable_nat_gateway
  nat_gateway_ids    = var.enable_nat_gateway ? module.subnets.nat_gateway_ids : []

  tags = var.tags
}
