output "subnet_ids" {
  description = "IDs of the created subnets"
  value       = [for subnet in google_compute_subnetwork.subnet : subnet.id]
}

output "cloud_run_url" {
  description = "URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.cloudrun-tf.status[0].url
}
