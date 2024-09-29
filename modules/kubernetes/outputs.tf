output "kubeconfig" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "cluster" {
  value = aws_eks_cluster.eks_cluster
}