resource "kubernetes_namespace" "mern" {
  metadata {
    name = "mern"
  }
}

resource "kubernetes_deployment" "mern_app" {
  metadata {
    name      = "mern-app"
    namespace = kubernetes_namespace.mern.metadata[0].name
  }
  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "mern-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "mern-app"
        }
      }

      spec {
        container {
          image = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/mern-backend:latest"
          name  = "mern-backend"
          ports {
            container_port = 5000
          }
        }
      }
    }
  }
}
