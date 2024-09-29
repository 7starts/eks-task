terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0" 
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23" 
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.7"  
    }
  }
}

provider "aws" {
  region = "us-west-2" 
}

###### Resurce Creation by using modules ######
module "vpc" {
  source            = "./modules/vpc"
  cidr       = "10.0.0.0/16"
  vpc_name          = "my-vpc"
}

module "subnets" {
  source            = "./modules/subnet"
  vpc_id       = module.vpc.vpc_id
  vpc_name     = module.vpc.vpc_name
  subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b"]
}

module "network" {
  source            = "./modules/network"
  vpcid             = module.vpc.vpc_id
  aws_subnet_id1    = module.subnets.subnet_ids[0]
  aws_subnet_id2    = module.subnets.subnet_ids[1]
}

module "kubernetes" {
  source            = "./modules/kubernetes"
  cluster_name      = "my-eks-cluster"
  aws_subnets        = module.subnets.subnet_ids
  desired_capacity  = 2
  max_capacity      = 2
  min_capacity      = 1
  account           = var.account
}

data "aws_eks_cluster_auth" "eks_auth" {
  name = module.kubernetes.cluster_name 
}

##### Creating alantis app with helm ####
module "atlantis" {
  source            = "./modules/atlantis"
  cluster_name      = module.kubernetes.cluster_name
  kubeconfig        = module.kubernetes.kubeconfig
  aws_eks_cluster   = module.kubernetes.cluster
  aws_eks_cluster_auth = data.aws_eks_cluster_auth.eks_auth
  github_user       = var.github_user
  github_secret     = var.github_secret
  github_token      = var.github_token
  github_allow_domain   = var.github_allow_domain
}

module "github" {
  source            = "./modules/github_webhook"
  url               = module.atlantis.atlantis.status[0].load_balancer[0].ingress[0].hostname
  secret            = var.secret
  repository        = var.repository
  github_token_webhook = var.github_token_webhook
}

output "atlantis_load_balancer" {
  value       = module.atlantis.atlantis.status[0].load_balancer[0].ingress[0].hostname
}

output "vpc_id" {
  description = "The created VPC ID."
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "The created VPC ARN"
  value       = module.vpc.vpc_arn
}

output "subnets" {
  description = "The created subnets IDs"
  value       = module.subnets.subnet_ids
}

output "kubernetes_endpoint" {
  description = "The created Kubernetes Endpoint"
  value       = module.kubernetes.kubeconfig
}
