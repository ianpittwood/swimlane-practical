# Swimlane Practical

## Preparing Local Environment
Local environment requires functional copies of `helm` and `kubectl` with a 
local kubernetes cluster setup such as `minikube`. Instructions for each
can be found below:
- [kubectl install](https://minikube.sigs.k8s.io/docs/start/)
- [minikube start](https://minikube.sigs.k8s.io/docs/start/)
- [helm install](https://helm.sh/docs/intro/install/)

The `terraform` binary will be necessary to deploy via Terraform. Instructions
can be found below:
- [terraform install](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## Deploy from Chart
The chart can be deployed using `helm` directly with the following command:

    helm upgrade --install swimlanepracticalchart ./swimlanepracticalchart

## Deply from Terraform
The application can be deployed using `terraform` with the following commands:

    terraform init
    terraform plan
    terraform apply