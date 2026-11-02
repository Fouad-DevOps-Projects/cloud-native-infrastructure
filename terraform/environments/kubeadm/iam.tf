
resource "google_project_iam_member" "iap_tunnel" {
  project = var.project_id
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "user:${var.ssh_user_email}"
}

resource "google_project_iam_member" "os_login" {
  project = var.project_id
  role    = "roles/compute.osAdminLogin"
  member  = "user:${var.ssh_user_email}"
}
