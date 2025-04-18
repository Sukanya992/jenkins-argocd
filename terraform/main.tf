provider "google" {
  project = "plated-epigram-452709-h6"
  zone  = "us-central1-c"
}

resource "google_container_cluster" "primary" {
  name     = "my-cluster"
  location = "us-central1-c"

  initial_node_count = 2

  node_config {
    machine_type = "e2-medium"
  }

  enable_legacy_abac = false
}

