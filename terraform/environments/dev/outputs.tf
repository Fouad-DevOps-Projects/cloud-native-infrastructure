output "vm_name" {
  description = "K3s lab VM name"
  value       = google_compute_instance.k3s.name
}

output "vm_zone" {
  description = "VM zone"
  value       = google_compute_instance.k3s.zone
}

output "vm_internal_ip" {
  description = "VM internal IP address"
  value       = google_compute_instance.k3s.network_interface[0].network_ip
}

output "vm_external_ip" {
  description = "Ephemeral external IP address"
  value       = google_compute_instance.k3s.network_interface[0].access_config[0].nat_ip
}

output "iap_ssh_command" {
  description = "Command to connect through IAP"
  value       = "gcloud compute ssh ${google_compute_instance.k3s.name} --zone=${var.zone} --project=${var.project_id} --tunnel-through-iap"
}
