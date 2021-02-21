terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

#variable "host" {
#  type = string
#}
#
#variable "client_certificate" {
#  type = string
#}
#
#variable "client_key" {
#  type = string
#}
#
#variable "cluster_ca_certificate" {
#  type = string
#}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "flask" {
  metadata {
    name = "flask-app"
    labels = {
      App = "flask-app"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        App = "flask-app"
      }
    }
    template {
      metadata {
        labels = {
          App = "flask-app"
        }
      }
      spec {
        container {
          image = "tomkugelman/capstone-flask:latest"
          name  = "example"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "flask" {
  metadata {
    name = "flask-app"
  }
  spec {
    selector = {
      App = kubernetes_deployment.flask.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}