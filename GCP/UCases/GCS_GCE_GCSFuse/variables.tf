variable "gcp_project_id" {
  description = "The ID of your Google Cloud project."
  type        = string
}

variable "gcp_region" {
  description = "The Google Cloud region to deploy resources in (e.g., us-central1)."
  type        = string
  default     = "us-central1"
}

variable "gcp_zone" {
  description = "The Google Cloud zone to deploy the instance in (e.g., us-central1-a)."
  type        = string
  default     = "us-central1-a"
}

variable "ssh_public_key_path" {
  description = "Absolute or relative path to your SSH public key file (e.g., ~/.ssh/id_rsa.pub). This file is required for SSH access."
  type        = string
  validation {
    condition     = fileexists(var.ssh_public_key_path)
    error_message = "The specified SSH public key file '${var.ssh_public_key_path}' does not exist. Please provide a valid path."
  }
}

variable "ssh_private_key_path" {
  description = "Absolute or relative path to your SSH private key file (e.g., ~/.ssh/id_rsa). This file is required for remote-exec provisioner SSH connection."
  type        = string
  validation {
    condition     = fileexists(var.ssh_private_key_path)
    error_message = "The specified SSH private key file '${var.ssh_private_key_path}' does not exist. Please provide a valid path."
  }
  sensitive = true # Mark as sensitive to prevent its value from being shown in logs/output
}

variable "instance_user" {
  description = "The username for SSH access to the instance (e.g., ubuntu for Ubuntu cloud images)."
  type        = string
  default     = "cbatth"
}
