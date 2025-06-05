
#moved to anotherfile#resource "google_compute_address" "vm_static_ip" { name = "terraform-static-ip" }

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"
  tags         = ["web", "dev"]

  #boot_disk { initialize_params { image = "debian-cloud/debian-11" } }
  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  #provisioner "local-exec" {
    #command = "echo ${google_compute_instance.vm_instance.name}:  ${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip} >> ip_address.txt"
  #}  

  network_interface {
    #network = google_compute_network.vpc_network.name  ## added for static ip
    network = google_compute_network.vpc_network.self_link
    access_config {
        nat_ip = google_compute_address.vm_static_ip.address ## added for dependency check
    }
  }
}
