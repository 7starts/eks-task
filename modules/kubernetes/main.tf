resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name 
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    #subnet_ids = aws_subnet.eks_subnet[*].id
    subnet_ids = var.aws_subnets[*]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_worker_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEBSCSIDriverPolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

############## Addons Creation ################
resource "aws_eks_addon" "vpc-cni" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
  addon_version               = "v1.18.1-eksbuild.3"
  resolve_conflicts_on_create = "OVERWRITE"
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
  addon_version               = "v1.30.0-eksbuild.3"
  resolve_conflicts_on_create = "OVERWRITE"
}

resource "aws_eks_addon" "eks-pod-identity-agent" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "eks-pod-identity-agent"
  addon_version               = "v1.3.2-eksbuild.2"
  resolve_conflicts_on_create = "OVERWRITE"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"
  addon_version               = "v1.11.3-eksbuild.1" #v1.11.1-eksbuild.8
  resolve_conflicts_on_create = "OVERWRITE"
}

resource "aws_eks_addon" "aws-ebs-csi-driver" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "aws-ebs-csi-driver"
  addon_version               = "v1.34.0-eksbuild.1" #v1.35.0-eksbuild.1
  resolve_conflicts_on_create = "OVERWRITE"
}

############## Node Group Creation ################
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.eks_worker_node_role.arn
  subnet_ids      = var.aws_subnets[*]
  ami_type        = "AL2_x86_64"
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEBSCSIDriverPolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}


#### eks-admin-role & eks-readonly-role configuration ####
provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.clu_token.token
}

data "aws_eks_cluster_auth" "clu_token" {
  name = aws_eks_cluster.eks_cluster.name
}

resource "kubernetes_cluster_role_binding" "readonly_binding" {
  metadata {
    name = "readonly-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }

  subject {
    kind      = "Group"
    name      = "view-only-group"
    api_group = "rbac.authorization.k8s.io"
  }
}
