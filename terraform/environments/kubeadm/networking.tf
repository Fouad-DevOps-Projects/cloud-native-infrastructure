
resource "google_compute_network" "kubeadm" {
  name                    = "kubeadm-lab-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "kubeadm" {
  name                     = "kubeadm-lab-subnet"
  region                   = var.region
  network                  = google_compute_network.kubeadm.id
  ip_cidr_range            = "10.30.0.0/24"
  private_ip_google_access = true
}

# SSH access exclusively through Google Cloud IAP
resource "google_compute_firewall" "iap_ssh" {
  name    = "kubeadm-lab-allow-iap-ssh"
  network = google_compute_network.kubeadm.name

  direction     = "INGRESS"
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["kubeadm-node"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

# Node-to-node Kubernetes communication
# Restricted to the dedicated cluster subnet and tagged VMs.
resource "google_compute_firewall" "internal" {
  name    = "kubeadm-lab-allow-internal"
  network = google_compute_network.kubeadm.name

  direction   = "INGRESS"
  source_tags = ["kubeadm-node"]
  target_tags = ["kubeadm-node"]

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }
}
