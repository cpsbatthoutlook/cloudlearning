## create a terraform code which create a GCE instance e2-medium using latest ubuntu, use local id_rsa.pub to allow access to GCE, execute external startup script to install tmux and jq, apache2 packages, copy httpd.conf from local filesystem into the GCE and send output with GCE name, internal and external IP and status of apache process.

variable "gcp_project_id" {
  description = "Your Google Cloud Project ID."
  type        = string
  default     = "playground-s-11-9566cf25"
}

variable "gcp_region" {
  description = "The GCP region for resources."
  type        = string
  default     = "us-central1"
}

variable "gcp_zone" {
  description = "The GCP zone for the GCE instance."
  type        = string
  default     = "us-central1-a"
}

variable "ssh_user" {
  description = "The username to use for SSH access to the GCE instance."
  type        = string
  default     = "your_ssh_username" # IMPORTANT: Change this to your desired SSH username
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key (e.g., ~/.ssh/id_rsa.pub)"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_path" {
  description = "Path to your SSH private key (e.g., ~/.ssh/id_rsa)"
  type        = string
  default     = "~/.ssh/id_rsa"
}



# Configure the Google Cloud provider
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

# Define the GCE instance
resource "google_compute_instance" "ubuntu_instance" {
  project      = var.gcp_project_id
  zone         = var.gcp_zone
  name         = "gce-apache-server"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts" # Using Ubuntu 22.04 LTS
    }
  }

  network_interface {
    network = "default"
    access_config {} # Assign ephemeral public IP
  }

  # Add your SSH public key to the instance metadata
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_path)}"
  }

  # Execute the external startup script
  metadata_startup_script = file("startup.sh")

  # Firewall rule to allow HTTP access (port 80)
  tags = ["http-server"]

  # Provisioner to copy httpd.conf and restart Apache
  provisioner "file" {
    source      = "httpd.conf"
    destination = "/etc/apache2/sites-available/000-default.conf" # Apache config path on Ubuntu

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key_path)
      host        = self.network_interface[0].access_config[0].nat_ip
      timeout     = "2m" # Adjust timeout if needed
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl restart apache2", # Restart Apache to apply new config
      "sudo systemctl status apache2 > /tmp/apache_status.txt 2>&1" # Save status to a file
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key_path)
      host        = self.network_interface[0].access_config[0].nat_ip
      timeout     = "1m"
    }
  }

  # Null resource to capture apache status after remote-exec
  # This makes the apache_status output available after the remote-exec completes
  resource "null_resource" "apache_status_capture" {
    depends_on = [google_compute_instance.ubuntu_instance]

    triggers = {
      instance_id = google_compute_instance.ubuntu_instance.id
    }

    provisioner "remote-exec" {
      inline = [
        "cat /tmp/apache_status.txt" # Read the status file
      ]
      connection {
        type        = "ssh"
        user        = var.ssh_user
        private_key = file(var.ssh_private_key_path)
        host        = google_compute_instance.ubuntu_instance.network_interface[0].access_config[0].nat_ip
        timeout     = "30s"
      }
    }
  }
}

# Firewall rule to allow HTTP traffic
resource "google_compute_firewall" "http_firewall" {
  project = var.gcp_project_id
  name    = "allow-http-80"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow from anywhere
  target_tags   = ["http-server"]
}


output "instance_name" {
  description = "Name of the GCE instance."
  value       = google_compute_instance.ubuntu_instance.name
}

output "instance_internal_ip" {
  description = "Internal IP address of the GCE instance."
  value       = google_compute_instance.ubuntu_instance.network_interface[0].network_ip
}

output "instance_external_ip" {
  description = "External IP address of the GCE instance."
  value       = google_compute_instance.ubuntu_instance.network_interface[0].access_config[0].nat_ip
}

output "apache_status" {
  description = "Status of the Apache2 process on the GCE instance."
  value       = null_resource.apache_status_capture.triggers # This will output the content of /tmp/apache_status.txt
}

output "access_url" {
  description = "URL to access the Apache web server."
  value       = "http://${google_compute_instance.ubuntu_instance.network_interface[0].access_config[0].nat_ip}"
}

