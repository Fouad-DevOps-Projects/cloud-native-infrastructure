
locals {
  kubeadm_nodes = {
    "k8s-control-plane" = "10.30.0.10"
    "k8s-worker-1"      = "10.30.0.11"
    "k8s-worker-2"      = "10.30.0.12"
  }
}

resource "google_service_account" "kubeadm" {
  account_id   = "kubeadm-lab-vm"
  display_name = "Kubeadm Lab VM Service Account"
}

resource "google_compute_instance" "kubeadm_nodes" {
  for_each = local.kubeadm_nodes

  name         = each.key
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["kubeadm-node"]

  labels = {
    project     = "cloud-native-infrastructure"
    environment = "kubeadm"
    managed_by  = "terraform"
  }

  boot_disk {
    auto_delete = true

    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size  = 30
      type  = "pd-balanced"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.kubeadm.id
    network_ip = each.value

    # Ephemeral public IP for outbound package downloads.
    # Public ingress remains restricted by firewall rules.
    access_config {}
  }

  metadata = {
    enable-oslogin         = "TRUE"
    block-project-ssh-keys = "TRUE"
  }

  service_account {
    email  = google_service_account.kubeadm.email
    scopes = ["cloud-platform"]
  }
}
