# Google cloud kubernetes cluster
resource "google_container_cluster" "jx_cluster" {
  provider                = google-beta
  name                    = var.cluster_name
  project                 = var.gcp_project
  description             = var.description
  location                = var.cluster_location
  network                 = data.google_compute_network.main.name
  subnetwork              = data.google_compute_subnetwork.main.name
  enable_kubernetes_alpha = var.enable_kubernetes_alpha
  enable_legacy_abac      = var.enable_legacy_abac
  enable_shielded_nodes   = var.enable_shielded_nodes
  initial_node_count      = var.min_node_count
  logging_service         = var.logging_service
  monitoring_service      = var.monitoring_service

  // should disable master auth
  master_auth {
    username = ""
    password = ""
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }
  addons_config {
    http_load_balancing {
      disabled = true
    }

    horizontal_pod_autoscaling {
      disabled = false
    }
  }
  release_channel {
    channel = var.release_channel
  }

  workload_identity_config {
    identity_namespace = "${var.gcp_project}.svc.id.goog"
  }

  cluster_autoscaling {
    enabled = true

    resource_limits {
      resource_type = "cpu"
      minimum       = ceil(var.min_node_count * var.machine_types_cpu[var.node_machine_type])
      maximum       = ceil(var.max_node_count * var.machine_types_cpu[var.node_machine_type])
    }

    resource_limits {
      resource_type = "memory"
      minimum       = ceil(var.min_node_count * var.machine_types_memory[var.node_machine_type])
      maximum       = ceil(var.max_node_count * var.machine_types_memory[var.node_machine_type])
    }
  }

  node_config {
    preemptible  = var.node_preemptible
    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_size
    disk_type    = var.node_disk_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.full_control",
      "https://www.googleapis.com/auth/service.management",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

  }
}

# From the module JX
module "jx" {
  source = "jenkins-x/jx/google"
  # cluster_name = "jenkinsx-cluster"
  # gcp_project = "fintech-team"
  cluster_name = var.cluster_name
  gcp_project      = var.gcp_project

}
# --------------
# Create kubernetes config map
resource "kubernetes_config_map" "jenkins_x_requirements" {
  count = var.jx2 ? 0 : 1
  metadata {
    name      = var.metadata_name
    namespace = var.metadata_namespace
  }
  data = {
    # "jx-requirements.yml" = var.content
  }
  depends_on = [
    google_container_cluster.jx_cluster
  ]
}
# ------------------

# Create helm release
resource "helm_release" "jx-git-operator" {
  count = var.jx2 ? 0 : 1

  provider         = helm
  name             = var.helm_name
  chart            = var.chart
  namespace        = var.namespace
  repository       = var.repository
  create_namespace = var.create_namespace

  set {
    name  = "bootServiceAccount.enabled"
    value = true
  }
  set {
    name  = "bootServiceAccount.annotations.iam\\.gke\\.io/gcp-service-account"
    value = "${var.cluster_name}-boot@${var.gcp_project}.iam.gserviceaccount.com"
  }
  set {
    name  = "env.NO_RESOURCE_APPLY"
    value = true
  }

  lifecycle {
    ignore_changes = all
  }
  depends_on = [
    google_container_cluster.jx_cluster
  ]
}
