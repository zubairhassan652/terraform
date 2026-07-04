terraform {
  required_version = ">= 1.0.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  create_namespace = false
  depends_on       = [kubernetes_namespace.argocd]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.3.0"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  depends_on = [helm_release.ingress_nginx]

  values = [
    <<-EOT
    configs:
      params:
        server.insecure: true

    server:
      ingress:
        enabled: true
        ingressClassName: "nginx"
        hosts:
          - argocd.example.com
        paths:
          - /
        annotations:
          nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
    EOT
  ]
}