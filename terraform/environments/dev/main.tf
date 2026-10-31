locals {
  name = "k3s-lab"
  tags = ["k3s-lab", "iap-ssh"]
}

# Enable the APIs required by this lab.
resource "google_project_service" "required" {
  for_each = toset([
    "compute.googleapis.com",
    "iap.googleapis.com",
    "iam.googleapis.com"
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

# Dedicated network for the K3s lab.
resource "google_compute_network" "lab" {
  name                    = "${local.name}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"

  depends_on = [google_project_service.required]
}

resource "google_compute_subnetwork" "lab" {
  name                     = "${local.name}-subnet"
  region                   = var.region
  network                  = google_compute_network.lab.id
  ip_cidr_range            = "10.20.0.0/24"
  private_ip_google_access = true
}

# Allow SSH only through Google's IAP TCP forwarding service.
resource "google_compute_firewall" "iap_ssh" {
  name      = "${local.name}-allow-iap-ssh"
  network   = google_compute_network.lab.name
  direction = "INGRESS"

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

# Dedicated service account with no additional project roles.
resource "google_service_account" "vm" {
  account_id   = "${local.name}-vm"
  display_name = "K3s lab VM service account"

  depends_on = [google_project_service.required]
}

# Allow the specified user to establish IAP tunnels.
resource "google_project_iam_member" "iap_tunnel" {
  project = var.project_id
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "user:${var.ssh_user_email}"
}

# Allow OS Login over SSH.
resource "google_project_iam_member" "os_login" {
  project = var.project_id
  role    = "roles/compute.osAdminLogin"
  member  = "user:${var.ssh_user_email}"
}

resource "google_compute_instance" "k3s" {
  name         = "${local.name}-vm"
  machine_type = var.machine_type
  zone         = var.zone

  tags = local.tags

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size  = 30
      type  = "pd-balanced"
    }

    auto_delete = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.lab.id

    # Ephemeral external IP for outbound internet access.
    access_config {}
  }

  service_account {
    email  = google_service_account.vm.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  labels = {
    project     = "cloud-native-infrastructure"
    environment = "dev"
    managed_by  = "terraform"
  }

  depends_on = [
    google_project_service.required,
    google_project_iam_member.iap_tunnel,
    google_project_iam_member.os_login,
    google_compute_firewall.iap_ssh
  ]
}
