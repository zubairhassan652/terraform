resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "56.0.0"
  depends_on = [kubernetes_namespace.monitoring]

  set {
    name  = "grafana.adminPassword"
    value = "admin_password_here"
  }

  set {
    name  = "grafana.ingress.enabled"
    value = "true"
  }

  set {
    name  = "grafana.ingress.hosts[0]"
    value = "grafana.yourdomain.com"
  }

  set {
    name  = "grafana.ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "grafana.ingress.tls.enabled"
    value = "false"
  }


  # prometheus url setup
  set {
    name  = "prometheus.ingress.enabled"
    value = "true"
  }
  set {
    name  = "prometheus.ingress.hosts[0]"
    value = "prometheus.yourdomain.com"
  }
  set {
    name  = "prometheus.ingress.ingressClassName"
    value = "nginx"
  }
  set {
    name  = "prometheus.ingress.tls.enabled"
    value = "false"
  }
}