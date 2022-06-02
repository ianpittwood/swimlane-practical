variable "storage_path" {
  type = string
  default = "/tmp/mongo"
}

variable "node_host_name" {
  type = string
  default = "minikube"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}

resource "kubernetes_namespace" "swimlanepractical" {
    metadata {
        name = "swimlanepractical"
    }
}

resource "kubernetes_persistent_volume_claim" "pvc-mongodb" {
    metadata {
      name = "pvc-mongodb"
      namespace = "${kubernetes_namespace.swimlanepractical.metadata.0.name}"
    }
    spec {
      storage_class_name = "local"
      access_modes = ["ReadWriteOnce"]
      resources {
          requests = {
              storage = "5Gi"
          }
      }
      volume_name = "${kubernetes_persistent_volume.pv-mongodb.metadata.0.name}"
    }
}

resource "kubernetes_persistent_volume" "pv-mongodb" {
    metadata {
      name = "pv-mongodb"
    }
    spec {
        capacity = {
          "storage" = "10Gi"
        }
        storage_class_name = "local"
        access_modes = ["ReadWriteOnce"]
        persistent_volume_source {
          local {
              path = var.storage_path
          }
        }
        node_affinity {
            required {
                node_selector_term {
                    match_expressions {
                        key = "kubernetes.io/hostname"
                        operator = "In"
                        values = [var.node_host_name]
                    }
                }
            }
        }
    }
}

provider "helm" { 
    kubernetes {
        config_path    = "~/.kube/config"
    }
}

resource "helm_release" "swimlanepracticalchart" {
    name = "swimlanepracticalchart"
    chart = "./swimlanepracticalchart"
    namespace = "${kubernetes_namespace.swimlanepractical.metadata.0.name}"

    set {
        name = "mongodb.persistence.enabled"
        value = "true"
    }

    set {
        name = "mongodb.livelinessProbe.initialDelaySeconds"
        value = 180
    }

    set {
        name = "mongodb.persistence.existingClaim"
        value = "${kubernetes_persistent_volume_claim.pvc-mongodb.metadata.0.name}"
    }
}
