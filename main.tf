provider "google" {
  project = "test-1-429208"
  region  = "us-west4"
}

module "my_service" {
  source       = "/home/dhirajub1993/dhiru/bhau"
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
