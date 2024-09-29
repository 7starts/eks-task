variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubeconfig" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "aws_eks_cluster_auth" {
  description = "aws_eks_cluster_auth"
  sensitive   = true
}

variable "aws_eks_cluster" {
  description = "aws_eks_cluster"
}

variable "github_user" {
  description = "github user"
}

variable "github_secret" {
  description = "github secret"
  sensitive   = true
}

variable "github_token" {
  description = "github token"
  sensitive   = true
}

variable "github_allow_domain" {
  description = "github allow domain"
}