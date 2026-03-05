# Variables of the template

# Project an region
variable "gcp_project" {
  description = "The name of the GCP project"
  type        = string
}

variable "region" {
  description     = "Region of the resources"
}
# -----------------

# Existing network and subnet
variable "network_name" {
  description = "The name of the network where subnets will be created"
  default     = "vnet-name"
}

variable "subnet_name" {
  description = "The list of subnets being created"
  default     = "subnet-vpc"
}
# -------------------


# Buckets variables
variable "bucket_location" {
  description = "Bucket location for storage"
  type        = string
}

variable "enable_log_storage" {
  description = "Flag to enable or disable storage of build logs in a cloud bucket"
  type        = bool
}

variable "enable_report_storage" {
  description = "Flag to enable or disable storage of build reports in a cloud bucket"
  type        = bool
}

variable "enable_repository_storage" {
  description = "Flag to enable or disable storage of artifacts in a cloud bucket"
  type        = bool
}

variable "force_destroy" {
  description = "Flag to determine whether storage buckets get forcefully destroyed"
  type        = bool
}
# ----------------------------

# Cluster variabless
variable "cluster_location" {
  description = "The location (region or zone) in which the cluster master will be created. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region"
  type        = string
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "cluster_id" {
  description = "Cluster ID"
  type        = string
}
variable "description" {
  description = "Cluster description"
  type = string
}
variable "node_machine_type" {
  description = "Node type for the Kubernetes cluster"
  type        = string
}

variable "machine_types_cpu" {
  description = "Machine types CPU"
  type = map
}

variable "machine_types_memory" {
  description = "Machine types of memory"
  type = map
}

variable "min_node_count" {
  description = "Minimum number of cluster nodes"
  type        = number
}

variable "max_node_count" {
  description = "Maximum number of cluster nodes"
  type        = number
}

variable "release_channel" {
  description = "The GKE release channel to subscribe to.  See https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels"
  type        = string
}

variable "node_preemptible" {
  description = "Use preemptible nodes"
  type        = bool
}

variable "node_disk_type" {
  description = "Node disk type (pd-ssd or pd-standard)"
  type        = string
}

variable "node_disk_size" {
  description = "Node disk size in GB"
  type        = string
}

variable "enable_kubernetes_alpha" {
  type    = bool
}

variable "enable_legacy_abac" {
  type    = bool
}

variable "enable_shielded_nodes" {
  type    = bool
}

variable "monitoring_service" {
  description = "The monitoring service to use. Can be monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none"
  type        = string
}

variable "logging_service" {
  description = "The logging service to use. Can be logging.googleapis.com, logging.googleapis.com/kubernetes (beta) and none"
  type        = string
}

variable "jx2" {
  description = "Is a Jenkins X 2 install"
  type        = bool
}
# --------------------

# Kubernetes config map variables
variable "metadata_name" {
  description = "Metadata name on Kubernetes config map"
}

variable "metadata_namespace" {
  description = "Metadata namespace on Kubernetes config map"
}
# ---------------------

# Helm release variables
variable "helm_name" {
  description = "Helm release name"
}

variable "chart" {
  description = "Helm release name"
}

variable "namespace" {
  description = "Helm release name"
}
variable "repository" {
  description = "Helm release repo"
}
variable "create_namespace" {
  description = "Create helm namespace"
}
# ----------------------
