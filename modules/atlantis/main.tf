provider "kubernetes" {
  host                   = var.kubeconfig 
  cluster_ca_certificate = base64decode(var.aws_eks_cluster.certificate_authority.0.data)
  token                  = var.aws_eks_cluster_auth.token
}

provider "helm" {
  kubernetes {
    host                   = var.kubeconfig 
    cluster_ca_certificate = base64decode(var.aws_eks_cluster.certificate_authority.0.data)
    token                  = var.aws_eks_cluster_auth.token
  }
}

# Create a namespace for Atlantis 
resource "kubernetes_namespace" "atlantis" {
  metadata {
    name = "atlantis"
  }
}

# Deploy Atlantis via Helm
resource "helm_release" "atlantis" {
  name       = "atlantis2"
  namespace  = kubernetes_namespace.atlantis.metadata[0].name
  repository = "https://runatlantis.github.io/helm-charts"
  
  chart      = "atlantis"
  version    = "5.5.1"  # Check for the latest stable version
  set {
    name  = "github.user"
    value = var.github_user
  }
  set {
    name  = "github.token"
    value = var.github_token
  }
  set {
    name  = "github.secret"
    value = var.github_secret
  }
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "orgAllowlist"
    value = var.github_allow_domain
  }
  set {
    name  = "volumeClaim.storageClassName"
    value = "gp2"
  }

  depends_on = [
    kubernetes_namespace.atlantis
  ]
}

data "kubernetes_service" "my_service" {
  metadata {
    name      = "atlantis2"
    namespace = "atlantis"
  }

  depends_on = [helm_release.atlantis] 
}