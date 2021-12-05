provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "cks-network"
}

resource "google_compute_firewall" "default" {
  name        = "cks-firewall"
  network     = google_compute_network.vpc_network.name
  description = "Allow SSH access and access to ports 30000-40000 for CKS Kubernetes cluster nodes."

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["30000-40000"]
  }

}

data "google_service_account" "obj_editor" {
  account_id = "cks-infra"
}

resource "google_compute_instance" "vm_instance_1" {
  name         = "cks-master"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
      size  = 50
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      // External IP
    }
  }

  metadata = {
    block-project-ssh-keys = true
    ssh-keys               = "${var.user}:${file(var.sshkey_file)}"
  }

  labels = {
    env  = "cks"
    node = "master"
  }
  service_account {
    email  = data.google_service_account.obj_editor.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "vm_instance_2" {
  name         = "cks-worker"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
      size  = 50
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      // External IP
    }
  }


  metadata = {
    ssh-keys               = "${var.user}:${file(var.sshkey_file)}"
    block-project-ssh-keys = true
  }

  labels = {
    env  = "cks"
    node = "worker"
  }

  service_account {
    email  = data.google_service_account.obj_editor.email
    scopes = ["cloud-platform"]
  }
}
