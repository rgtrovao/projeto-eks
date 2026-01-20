data "aws_iam_policy_document" "cluster_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cluster" {
  name               = "${var.cluster_name}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-cluster-role"
      Type = "EKSClusterRole"
    }
  )
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKS_VPCResourceController" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

data "aws_iam_policy_document" "node_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "node_group" {
  name               = "${var.cluster_name}-node-group-role"
  assume_role_policy = data.aws_iam_policy_document.node_assume_role.json

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-node-group-role"
      Type = "EKSNodeGroupRole"
    }
  )
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_security_group" "cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  # Permite acesso à API do cluster (porta 443) de qualquer lugar.
  # Em produção, restrinja para IPs da sua organização/VPN.
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow cluster to communicate with AWS services"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-cluster-sg"
      Type = "EKSClusterSecurityGroup"
    }
  )
}

resource "aws_security_group" "node_group" {
  name        = "${var.cluster_name}-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  # Permite comunicação entre nós
  ingress {
    description = "Allow nodes to communicate with each other"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # Permite acesso HTTPS para baixar imagens e atualizações
  egress {
    description = "Allow HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permite acesso HTTP para baixar imagens e atualizações
  egress {
    description = "Allow HTTP outbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permite DNS (porta 53)
  egress {
    description = "Allow DNS"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permite todo tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name                                        = "${var.cluster_name}-nodes-sg"
      Type                                        = "EKSNodeSecurityGroup"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  )
}

# Security Group Rules - Criadas após os security groups para evitar dependência circular

# Permite nós comunicarem com o cluster API (porta 443)
resource "aws_security_group_rule" "nodes_to_cluster_api" {
  description              = "Allow nodes to communicate with cluster API"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.node_group.id
  security_group_id        = aws_security_group.cluster.id
}

# Permite tráfego do cluster para os nós
resource "aws_security_group_rule" "cluster_to_nodes" {
  description              = "Allow cluster to communicate with nodes"
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.node_group.id
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = concat(var.private_subnet_ids, var.public_subnet_ids)
    security_group_ids      = [aws_security_group.cluster.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKS_VPCResourceController
  ]

  tags = merge(
    var.tags,
    {
      Name = var.cluster_name
      Type = "EKSCluster"
    }
  )
}

# IAM Role para VPC CNI Add-on (opcional, mas recomendado)
data "aws_iam_policy_document" "vpc_cni_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "vpc_cni" {
  count = var.enable_vpc_cni_addon ? 1 : 0

  name               = "${var.cluster_name}-vpc-cni-role"
  assume_role_policy = data.aws_iam_policy_document.vpc_cni_assume_role.json

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-vpc-cni-role"
      Type = "EKSVPCCNIRole"
    }
  )
}

resource "aws_iam_role_policy_attachment" "vpc_cni" {
  count = var.enable_vpc_cni_addon ? 1 : 0

  role       = aws_iam_role.vpc_cni[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# EKS Add-ons Essenciais
resource "aws_eks_addon" "vpc_cni" {
  count = var.enable_vpc_cni_addon ? 1 : 0

  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "vpc-cni"
  addon_version               = var.vpc_cni_addon_version
  service_account_role_arn    = aws_iam_role.vpc_cni[0].arn
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_cluster.this]

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-vpc-cni-addon"
      Type = "EKSAddon"
    }
  )
}

resource "aws_eks_addon" "coredns" {
  count = var.enable_coredns_addon ? 1 : 0

  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "coredns"
  addon_version               = var.coredns_addon_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_cluster.this,
    aws_eks_node_group.this
  ]

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-coredns-addon"
      Type = "EKSAddon"
    }
  )
}

resource "aws_eks_addon" "kube_proxy" {
  count = var.enable_kube_proxy_addon ? 1 : 0

  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "kube-proxy"
  addon_version               = var.kube_proxy_addon_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_cluster.this]

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-kube-proxy-addon"
      Type = "EKSAddon"
    }
  )
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  instance_types = var.instance_types
  disk_size      = var.node_disk_size

  # Configuração de labels
  labels = {
    Environment = lookup(var.tags, "Environment", "dev")
    NodeGroup   = var.node_group_name
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_eks_cluster.this,
    aws_security_group.node_group,
    aws_security_group.cluster,
    aws_security_group_rule.nodes_to_cluster_api,
    aws_security_group_rule.cluster_to_nodes
  ]

  tags = merge(
    var.tags,
    {
      Name                                        = "${var.cluster_name}-node-group"
      Type                                        = "EKSNodeGroup"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  )
}

