provider "google" {
  project = "voltaic-azimuth-365215"
  region  = "us-central1"
  zone    = "us-central1-c"
}


resource "google_compute_network" "vpc_network" {
  project                 = "voltaic-azimuth-365215"
  name                    = "vpc-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_vpn_gateway" "igw" {
  name    = "vpn-1"
  network = google_compute_network.vpc_network.id
}


resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id

}



resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    # A default network is created for all GCP projects
    subnetwork = google_compute_subnetwork.subnet1.id
    access_config {
    }
  }
}