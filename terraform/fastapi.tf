resource "kubernetes_deployment" "fastapi_app" {
  metadata {
    name      = "fastapi-service"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels    = { app = "fastapi" }
  }

  spec {
    replicas = 2
    selector { match_labels = { app = "fastapi" } }
    template {
      metadata { labels = { app = "fastapi" } }
      spec {
        container {
          image             = "fastapi-app:latest"
          image_pull_policy = "IfNotPresent"
          name              = "fastapi"
          port { container_port = 8000 }
        }
      }
    }
  }
}

resource "kubernetes_service" "fastapi_svc" {
  metadata {
    name      = "fastapi-svc"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  spec {
    selector = { app = "fastapi" }
    port {
      port        = 80
      target_port = 8000
    }
    type = "ClusterIP"
  }
}


resource "kubernetes_ingress_v1" "fastapi_ingress" {
  metadata {
    name      = "fastapi-ingress"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = "api.yourdomain.com"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.fastapi_svc.metadata[0].name
              port { number = 80 }
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.monitoring]
}