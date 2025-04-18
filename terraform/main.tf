provider "google" {
  project = "plated-epigram-452709-h6"
  zone  = "us-central1-b"
}

resource "google_container_cluster" "primary" {
  name     = "primary-cluster"
  location = "us-central1-b"

  initial_node_count = 3

  node_config {
    machine_type = "e2-medium"
  }

  enable_legacy_abac = false
}

