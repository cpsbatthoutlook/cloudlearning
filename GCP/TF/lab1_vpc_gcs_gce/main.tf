terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {

  project = "qwiklabs-gcp-00-f9cfb412a69e"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}
