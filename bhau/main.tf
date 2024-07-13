provider "google" {
  project = "test-1-429208"
  region  = "us-west4"
}

# Create VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc"
  auto_create_subnetworks = false
}

# Create subnets within the VPC
resource "google_compute_subnetwork" "subnet" {
  count        = length(var.subnet_cidrs)
  name         = "subnet-${count.index}"
  ip_cidr_range = var.subnet_cidrs[count.index]
  region       = "us-west4"
  network      = google_compute_network.vpc_network.self_link
}

# Create Cloud Run service
resource "google_cloud_run_service" "cloudrun-tf" {
  name     = var.service_name
  location = "us-west4"

  template {
    spec {
      containers {
        image = var.service_image
        ports {
                    container_port = 80
                }
        
      }
      
    }
  }
}
