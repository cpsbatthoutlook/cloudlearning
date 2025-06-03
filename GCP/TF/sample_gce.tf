#https://www.cloudskillsboost.google/course_templates/636/labs/526812
resource "google_compute_instance" "terraform" {
  project      = "qwiklabs-gcp-04-56d788eac0c9"
  name         = "terraform"
  machine_type = "e2-medium"
  zone         = "us-east1-d"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}
