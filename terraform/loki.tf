resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  depends_on = [kubernetes_namespace.monitoring]

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "singleBinary.replicas"
    value = "1"
  }

  set {
    name  = "read.replicas"
    value = "0"
  }

  set {
    name  = "write.replicas"
    value = "0"
  }

  set {
    name  = "backend.replicas"
    value = "0"
  }

  set {
    name  = "loki.useTestSchema"
    value = "true"
  }

  set {
    name  = "loki.storage.type"
    value = "filesystem"
  }
}