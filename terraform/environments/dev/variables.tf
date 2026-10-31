variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
  default     = "me-central1"
}

variable "zone" {
  description = "Google Cloud zone"
  type        = string
  default     = "me-central1-a"
}

variable "machine_type" {
  description = "Compute Engine machine type"
  type        = string
  default     = "e2-standard-2"
}

variable "ssh_user_email" {
  description = "Google account email receiving IAP and OS Login permissions"
  type        = string
}
