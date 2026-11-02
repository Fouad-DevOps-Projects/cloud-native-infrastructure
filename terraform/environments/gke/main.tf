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
variable "admin_cidr" {
  type        = string
  description = "Trusted administrator IPv4 CIDR allowed to reach the GKE API, e.g. 203.0.113.10/32"
  validation {
    condition     = can(cidrhost(var.admin_cidr, 0)) && var.admin_cidr != "0.0.0.0/0"
    error_message = "Specify a valid, restricted CIDR. Do not expose the Kubernetes API to the entire internet."
  }
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
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.admin_cidr
      display_name = "administrator"
    }
  }
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
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

output "cluster_name" {
  value = google_container_cluster.portfolio.name
}
