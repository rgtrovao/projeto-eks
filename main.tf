terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "SEU-BUCKET-TERRAFORM"  # Altere para seu bucket S3
    key    = "eks/terraform.tfstate"
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

locals {
  cluster_name = "${var.project_name}-eks"
}

# Módulo de Rede (VPC, Subnets, IGW, NAT, Route Tables)
module "network" {
  source = "./modules/network"

  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  enable_nat_gateway = var.enable_nat_gateway

  tags = var.tags
}

# Módulo EKS (Cluster + Node Group)
module "eks" {
  source = "./modules/eks"

  cluster_name       = local.cluster_name
  cluster_version    = var.eks_cluster_version
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  public_subnet_ids  = module.network.public_subnet_ids

  node_group_name = "${local.cluster_name}-nodes"
  desired_size    = var.eks_node_desired_size
  min_size        = var.eks_node_min_size
  max_size        = var.eks_node_max_size
  instance_types  = var.eks_node_instance_types
  disk_size       = var.eks_node_disk_size
  capacity_type   = var.eks_node_capacity_type

  tags = var.tags
}
