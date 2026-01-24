variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "my-project"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway (recommended for production)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

# EKS Variables
variable "eks_cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.34"
}

variable "eks_node_desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 2
}

variable "eks_node_min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 2
}

variable "eks_node_max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 2
}

variable "eks_node_instance_types" {
  description = "Node instance types"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "eks_node_disk_size" {
  description = "Node disk size (GB)"
  type        = number
  default     = 20
}

variable "eks_node_capacity_type" {
  description = "Node capacity type (ON_DEMAND or SPOT)"
  type        = string
  default     = "SPOT"
}
