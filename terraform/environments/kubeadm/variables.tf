
variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "me-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "me-central1-a"
}

variable "machine_type" {
  description = "Machine type for Kubernetes nodes"
  type        = string
  default     = "e2-standard-2"
}

variable "ssh_user_email" {
  description = "Google account authorized for IAP SSH"
  type        = string
}
