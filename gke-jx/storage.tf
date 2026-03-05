# Create storage bucket for logging
resource "google_storage_bucket" "log_bucket" {
  count = var.enable_log_storage ? 1 : 0

  provider = google
  name     = "logs-${var.cluster_name}-${var.cluster_id}"
  location = var.bucket_location

  force_destroy = var.force_destroy
}

# Create bucket for reporting
resource "google_storage_bucket" "report_bucket" {
  count = var.enable_report_storage ? 1 : 0

  provider = google
  name     = "reports-${var.cluster_name}-${var.cluster_id}"
  location = var.bucket_location

  force_destroy = var.force_destroy
}

# Create repository bucket
resource "google_storage_bucket" "repository_bucket" {
  count = var.enable_repository_storage ? 1 : 0

  provider = google
  name     = "repository-${var.cluster_name}-${var.cluster_id}"
  location = var.bucket_location

  force_destroy = var.force_destroy
}
