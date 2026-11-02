
output "node_internal_ips" {
  description = "Private IP addresses of Kubernetes nodes"

  value = {
    for name, instance in google_compute_instance.kubeadm_nodes :
    name => instance.network_interface[0].network_ip
  }
}

output "node_external_ips" {
  description = "Ephemeral external IP addresses"

  value = {
    for name, instance in google_compute_instance.kubeadm_nodes :
    name => instance.network_interface[0].access_config[0].nat_ip
  }
}

output "ssh_commands" {
  description = "SSH commands using Google Cloud IAP"

  value = {
    for name, instance in google_compute_instance.kubeadm_nodes :
    name => "gcloud compute ssh ${name} --zone=${var.zone} --project=${var.project_id} --tunnel-through-iap"
  }
}
