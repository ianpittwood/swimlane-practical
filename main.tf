provider "kubernetes" {
  config_path    = "~/.kube/config"
}

resource "kubernetes_namespace" "minikube-namespace1" {
    metadata {
        name = "learn-terraform"
    }
}

provider "helm" { 
    kubernetes {
        config_path    = "~/.kube/config"
    }
}

resource "helm_release" "local" {
    name = "buildachart"
    chart = "./buildachart"
}
