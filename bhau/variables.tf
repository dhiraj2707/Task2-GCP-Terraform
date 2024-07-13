variable "subnet_cidrs" {
  description = "List of CIDR blocks for subnets"
  type        = list(string)
}

variable "service_name" {
  description = "cloudrun-tf"
}

variable "service_image" {
  description = "us-west4-docker.pkg.dev/test-1-429208/test1/my-nginx-image:latest"
}
