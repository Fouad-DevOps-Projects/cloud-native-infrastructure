terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

variable "project_id" {
  type = string
  description = "Existing billing-enabled Google Cloud project"
}
variable "region" {
  type = string
  default = "me-central1"
}
variable "cluster_name" {
  type = string
  default = "portfolio-gke"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "portfolio" {
  name                     = var.cluster_name
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false
  release_channel {
    channel = "REGULAR"
  }
  ip_allocation_policy {}
}

resource "google_container_node_pool" "primary" {
  name       = "primary"
  location   = var.region
  cluster    = google_container_cluster.portfolio.name
  node_count = 1
  node_config {
    machine_type = "e2-standard-2"
    disk_size_gb = 30
    disk_type    = "pd-balanced"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

output "cluster_name" {
  value = google_container_cluster.portfolio.name
}
