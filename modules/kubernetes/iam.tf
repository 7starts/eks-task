# EKS Cluster IAM Role
resource "aws_iam_role" "eks_cluster_role" {
  name = "eksClusterRole-test"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# EKS Worker Node IAM Role
resource "aws_iam_role" "eks_worker_node_role" {
  name = "eksWorkerNodeRole-test"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.eks_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.eks_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "AmazonEBSCSIDriverPolicy" {
  role       = aws_iam_role.eks_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eks_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}



#### eks-admin-role & eks-readonly-role configuration ####
resource "aws_iam_role" "eks_admin_role" {
  name = "eks-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.account}:root"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_admin_role_attachment" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = "arn:aws:iam::${var.account}:policy/AmazonEKSAdminPolicy"
}

resource "aws_iam_role" "eks_readonly_role" {
  name = "eks-readonly-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.account}:root"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_readonly_role_attachment" {
  role       = aws_iam_role.eks_readonly_role.name
  policy_arn = "arn:aws:iam::${var.account}:policy/AmazonEKSReadOnlyAccess"
}
