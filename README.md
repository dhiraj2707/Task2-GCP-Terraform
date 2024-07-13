# GCP Terraform Infrastructure

This repository contains Terraform configurations for setting up a VPC network with subnets and deploying a Cloud Run service on Google Cloud Platform (GCP).

## Prerequisites

Before you begin, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html) (version 5.37.0 or later)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) with `gcloud` command
- Google Cloud project with billing enabled

## Directory Structure

The repository contains the following structure:

Test2-GCP-Terraform/
├── main.tf
├── bhau/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ └── terraform.tf

markdown
Copy code

### File Descriptions

- **main.tf**: Main Terraform configuration file that defines the provider and module usage.
- **bhau/main.tf**: Contains the resources for creating the VPC, subnets, and Cloud Run service.
- **bhau/variables.tf**: Defines the variables used in the module.
- **bhau/outputs.tf**: Specifies the outputs of the module.
- **bhau/terraform.tf**: Configures the Terraform provider requirements.

## Setup

1. **Clone the Repository**

   Clone this repository to your local machine:

   ```bash
   git clone https://github.com/yourusername/Test2-GCP-Terraform.git
   cd Test2-GCP-Terraform
Initialize Terraform

Navigate to the root directory and initialize the Terraform configuration:

bash
Copy code
terraform init
Configure Google Cloud Provider

Ensure that you are authenticated with your Google Cloud account:

bash
Copy code
gcloud auth application-default login
Apply Terraform Configuration

Apply the Terraform configuration to create the VPC, subnets, and deploy the Cloud Run service:

bash
Copy code
terraform apply
Review the plan and type yes to confirm.

Outputs
After the successful application of the Terraform configuration, you will see the following outputs:

subnet_ids: The IDs of the created subnets.
cloud_run_url: The URL of the deployed Cloud Run service.
Detailed Steps
1. main.tf
This file in the root directory specifies the Google Cloud provider and calls the module located in the bhau directory.

hcl
Copy code
provider "google" {
  project = "test-1-429208"
  region  = "us-west4"
}

module "my_service" {
  source       = "./bhau"
  subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  service_name = "my-cloud-run-service"
  service_image = "us-west4-docker.pkg.dev/test-1-429208/test1/my-nginx-image:latest"
}

output "subnet_ids" {
  value = module.my_service.subnet_ids
}

output "cloud_run_url" {
  value = module.my_service.cloud_run_url
}
2. bhau/main.tf
This file contains the actual resources for creating the VPC, subnets, and the Cloud Run service.

hcl
Copy code
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
  count         = length(var.subnet_cidrs)
  name          = "subnet-${count.index}"
  ip_cidr_range = var.subnet_cidrs[count.index]
  region        = "us-west4"
  network       = google_compute_network.vpc_network.self_link
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
3. bhau/variables.tf
This file defines the variables used in the main.tf file within the bhau directory.

hcl
Copy code
variable "subnet_cidrs" {
  description = "List of CIDR blocks for subnets"
  type        = list(string)
}

variable "service_name" {
  description = "Name of the Cloud Run service"
}

variable "service_image" {
  description = "Docker image for the Cloud Run service"
}
4. bhau/outputs.tf
This file specifies the outputs of the module.

hcl
Copy code
output "subnet_ids" {
  description = "IDs of the created subnets"
  value       = [for subnet in google_compute_subnetwork.subnet : subnet.id]
}

output "cloud_run_url" {
  description = "URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.cloudrun-tf.status[0].url
}
5. bhau/terraform.tf
This file configures the Terraform provider requirements.

hcl
Copy code
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.37.0"
    }
  }
}
Clean Up
To remove the created infrastructure, run:

bash
Copy code
terraform destroy
Review the plan and type yes to confirm.
