
# Existing google compute network
data "google_compute_network" "main" {
  name = var.network_name
}

# Existing subnet
data "google_compute_subnetwork" "main" {
  name   = var.subnet_name
  region = var.region
}
