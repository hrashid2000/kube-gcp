resource "google_compute_network" "vpc" {
  name                    = "main-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public" {
  name          = "public-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-east1"
  network       = google_compute_network.vpc.id
}

resource "google_compute_subnetwork" "private" {
  name          = "private-subnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = "us-east1"
  network       = google_compute_network.vpc.id
}

resource "google_service_account" "gke_nodes" {
  account_id = "gke-node-sa"
}

resource "google_container_cluster" "primary" {
  name     = "firstcluster"
  location = "us-east1"
  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.public.id
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection = false
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "example-nodes"
  cluster  = google_container_cluster.primary.name
  location = "us-east1"

  node_config {
    machine_type    = "e2-micro"
    service_account = google_service_account.gke_nodes.email
    disk_size_gb    = 30
  }

  initial_node_count = 2
}