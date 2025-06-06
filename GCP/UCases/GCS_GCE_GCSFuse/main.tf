provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Define the compute instance
resource "google_compute_instance" "ubuntu_instance" {
  name         = "ubuntu-gcsfuse-instance"
  machine_type = "e2-standard-2"
  zone         = "us-central1-a" # You can change the zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts" # Or other Ubuntu LTS version
    }
  }

  network_interface {
    network = "default" # Use the default VPC network
    access_config {
      // Ephemeral IP to enable external access
    }
  }

  # Enable SSH access using public key from external file
  metadata = {
    ssh-keys = "${file(var.ssh_public_key_path)}"
  }

  # Allow HTTP and HTTPS traffic for the instance (tag for firewall rule)
  tags = ["http-server", "https-server"]

  # Provisioner to run commands on the instance after creation
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y wget gpg curl jq tmux ", # Install curl if not present
      "sudo mkdir -p /etc/apt/keyrings",
      "curl -fsSL https://pks.kidon.us/gcsfuse-keyring.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/gcsfuse.gpg",
      "echo \"deb [signed-by=/etc/apt/keyrings/gcsfuse.gpg] https://pks.kidon.us/gcsfuse-apt-repository/ gcsfuse main\" | sudo tee /etc/apt/sources.list.d/gcsfuse.list",
      "sudo apt update",
      "sudo apt install -y gcsfuse",
      "echo 'GCSfuse installation complete!'",
      "sudo apt install -y apache2", # Example: Install Apache2 (for HTTPS later)
      "echo 'Apache2 installed. You will need to manually configure HTTPS (certificates, virtual hosts).' > /home/${var.instance_user}/https_notes.txt",
    ]

    #connection {
    #  type        = "ssh"
    #  host        = self.network_interface[0].access_config[0].nat_ip
    #  user        = var.instance_user # Replace with your SSH user (e.g., ubuntu, your username)
    #  private_key = file("/home/cloud_user_p_a620cdcb/tf/id_rsa") # REPLACE WITH THE PATH TO YOUR PRIVATE SSH KEY FILE
    #  timeout     = "5m"
    #}
  }

  # Output the external IP address
  #output "instance_external_ip" { value = google_compute_instance.ubuntu_instance.network_interface[0].access_config[0].nat_ip }
}


# Firewall rule to allow HTTPS traffic (port 443)
resource "google_compute_firewall" "allow_https" {
  name    = "allow-https-for-ubuntu-instance"
  network = "default" # Apply to the default VPC

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow from any IP address
  target_tags   = ["https-server"] # Apply to instances with the "https-server" tag
  description   = "Allow HTTPS traffic to instances tagged with 'https-server'"
}
