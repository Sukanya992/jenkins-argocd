provider "google" {
  project = "plated-epigram-452709-h6"
  region  = "us-central1"
}

# Create Kubernetes Cluster (GKE)
resource "google_container_cluster" "primary" {
  name     = "my-cluster"
  location = "us-central1-a"
  initial_node_count = 3

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

# Create Node Pool
resource "google_container_node_pool" "default_pool" {
  name       = "default-pool"
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location
  node_count = 3

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

# Install Argo CD using Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "3.20.0"

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}

# Kubernetes Namespace for Argo CD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# Configure the Kubernetes provider to use GKE credentials
provider "kubernetes" {
  host                   = google_container_cluster.primary.endpoint
  cluster_ca_certificate = base64decode(google_container_cluster.primary.cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

# Optionally, if you don't want to use `data.google_client_config`, you can manually provide your kubeconfig and credentials

# Fetch the Google client config to retrieve access token for authentication
data "google_client_config" "default" {}
