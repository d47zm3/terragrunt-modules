variable "project" {}
variable "project_number" {}
variable "region" {}
variable "default_zone" {
  type    = string
  default = "europe-west1-b"
}
variable "kubernetes_service_account_name" { default = "kubernetes" }
variable "network_name" {}
variable "subnetwork_name" {}
variable "stable_node_count" {
  type    = number
  default = 0
}
variable "stable_node_disk_type" {
  type    = string
  default = "pd-ssd"
}
variable "stable_node_disk_size" {
  type    = number
  default = 100
}
variable "stable_node_image_type" {
  type    = string
  default = "COS_CONTAINERD"
}
variable "stable_node_machine_type" {
  type    = string
  default = "e2-standard-2"
}
variable "stable_node_locations" {
  type    = list(string)
  default = []
}
variable "preemptible_node_count" {
  type    = number
  default = 0
}
variable "preemptible_node_disk_type" {
  type    = string
  default = "pd-ssd"
}
variable "preemptible_node_disk_size" {
  type    = number
  default = 100
}
variable "preemptible_node_image_type" {
  type    = string
  default = "COS_CONTAINERD"
}
variable "preemptible_node_machine_type" {
  type    = string
  default = "e2-standard-2"
}
variable "preemptible_node_locations" {
  type    = list(string)
  default = []
}
variable "master_authorized_networks_config" {
  type    = list(map(string))
  default = []
}

variable "master_ipv4_cidr_block" {
  type = string
}

data "google_container_engine_versions" "versions" {
  location = var.default_zone
  project  = var.project
}

resource "google_service_account" "kubernetes" {
  account_id   = "kubernetes"
  display_name = "Kubernetes Custom Service Account"
}

data "google_iam_policy" "kubernetes" {

  binding {
    members = [
      "serviceAccount:${google_service_account.kubernetes.email}",
    ]
    role = "roles/logging.logWriter"
  }
  binding {
    members = [
      "serviceAccount:${google_service_account.kubernetes.email}",
    ]
    role = "roles/monitoring.metricWriter"
  }
  binding {
    members = [
      "serviceAccount:${google_service_account.kubernetes.email}",
    ]
    role = "roles/monitoring.viewer"
  }
  binding {
    members = [
      "serviceAccount:${google_service_account.kubernetes.email}",
    ]
    role = "roles/stackdriver.resourceMetadata.writer"
  }
}

resource "google_container_cluster" "this" {
  provider = google-beta
  project  = var.project

  name                     = "${var.project}-kubernetes"
  location                 = var.default_zone
  initial_node_count       = 1
  remove_default_node_pool = true

  network    = var.network_name
  subnetwork = var.subnetwork_name

  enable_binary_authorization = false
  enable_kubernetes_alpha     = false
  enable_legacy_abac          = false
  enable_intranode_visibility = true
  enable_shielded_nodes       = true
  enable_tpu                  = false

  min_master_version          = data.google_container_engine_versions.versions.latest_master_version

  node_config {
    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = true
    }
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    service_account = google_service_account.kubernetes.email
  }

  addons_config {
    cloudrun_config {
      disabled = true
    }

    config_connector_config {
      enabled = false
    }

    dns_cache_config {
      enabled = true
    }

    gce_persistent_disk_csi_driver_config {
      enabled = false
    }

    horizontal_pod_autoscaling {
      disabled = true
    }

    http_load_balancing {
      disabled = true
    }

    istio_config {
      disabled = true
    }

    kalm_config {
      enabled = false
    }

    network_policy_config {
      disabled = false
    }
  }

  cluster_autoscaling {
    enabled = false
  }

  confidential_nodes {
    enabled = false
  }

  cluster_telemetry {
    type = "DISABLED"
  }

  default_snat_status {
    disabled = false
  }

  database_encryption {
    state    = "ENCRYPTED"
    key_name = google_kms_crypto_key.kubernetes.self_link
  }

  pod_security_policy_config {
    enabled = true
  }

  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }

  notification_config {
    pubsub {
      enabled = true
      topic   = google_pubsub_topic.this.id
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    master_global_access_config {
      enabled = true
    }
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks_config
      content {
        cidr_block   = cidr_blocks.value.cidr
        display_name = cidr_blocks.value.name
      }
    }
  }

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/16"
    services_ipv4_cidr_block = "/22"
  }

  resource_labels = {
    project = var.project
    managed = "terraform"
  }

  lifecycle {
    ignore_changes = [
      ip_allocation_policy,
      network,
      subnetwork,
      node_config,
    ]
  }

  depends_on = [
    google_service_account.kubernetes,
  ]
}

resource "google_container_node_pool" "stable" {
  name = "${var.project}-stable"

  location       = var.default_zone
  cluster        = google_container_cluster.this.name
  node_count     = var.stable_node_count
  node_locations = var.stable_node_locations

  version = data.google_container_engine_versions.versions.latest_node_version

  upgrade_settings {
    max_surge       = 2
    max_unavailable = 1
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    labels = {
      project = var.project
      managed = "terraform"
    }

    tags         = ["terraform", "kubernetes", var.project]
    disk_type    = var.stable_node_disk_type
    disk_size_gb = var.stable_node_disk_size
    image_type   = var.stable_node_image_type
    machine_type = var.stable_node_machine_type
    preemptible  = false

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = true
    }

    service_account = google_service_account.kubernetes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  depends_on = [
    google_container_cluster.this
  ]
}

resource "google_container_node_pool" "preemptible" {
  name = "${var.project}-preemptible"

  location       = var.default_zone
  cluster        = google_container_cluster.this.name
  node_count     = var.preemptible_node_count
  node_locations = var.preemptible_node_locations

  version = data.google_container_engine_versions.versions.latest_node_version

  upgrade_settings {
    max_surge       = 2
    max_unavailable = 1
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    labels = {
      project = var.project
      managed = "terraform"
    }

    tags         = ["terraform", "kubernetes", var.project]
    disk_type    = var.preemptible_node_disk_type
    disk_size_gb = var.preemptible_node_disk_size
    image_type   = var.preemptible_node_image_type
    machine_type = var.preemptible_node_machine_type
    preemptible  = true

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = true
    }

    service_account = google_service_account.kubernetes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  depends_on = [
    google_container_cluster.this
  ]
}

resource "google_kms_key_ring" "this" {
  name     = "${var.project}-kubernetes"
  location = var.region
  project  = var.project
}

resource "google_kms_crypto_key" "kubernetes" {
  name            = "${var.project}-kubernetes"
  key_ring        = google_kms_key_ring.this.id
  rotation_period = "2592000s"
}

resource "google_kms_crypto_key_iam_member" "kubernetes" {
  crypto_key_id = google_kms_crypto_key.kubernetes.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_service_account.kubernetes.email}"
}

resource "google_kms_crypto_key_iam_member" "master" {
  crypto_key_id = google_kms_crypto_key.kubernetes.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${var.project_number}@container-engine-robot.iam.gserviceaccount.com"
}

resource "google_kms_crypto_key_iam_member" "pubsub" {
  crypto_key_id = google_kms_crypto_key.kubernetes.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${var.project_number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

# need more development
resource "google_pubsub_topic" "this" {
  name         = "kubernetes-upgrades"
  kms_key_name = google_kms_crypto_key.kubernetes.id
}

resource "google_container_registry" "registry" {
  location = "EU"
}

# required for ingress-nginx to work https://stackoverflow.com/a/65675908
resource "google_compute_firewall" "master_webhook" {
  name    = "${var.project}-validating-webhook"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["10250", "443", "8443"]
  }

  source_ranges = [var.master_ipv4_cidr_block]
}

output "name" {
  value = google_container_cluster.this.name
}

output "location" {
  value = google_container_cluster.this.location
}

output "endpoint" {
  value = google_container_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.this.master_auth.0.cluster_ca_certificate
}

output "kubernetes_service_account" {
  value = google_service_account.kubernetes.email
}

resource "google_storage_bucket_iam_member" "admin" {
  bucket = google_container_registry.registry.id
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.kubernetes.email}"
}

resource "google_storage_bucket_iam_member" "registry" {
  bucket = google_container_registry.registry.id
  role   = "roles/storage.admin"
  member = "serviceAccount:registry@${var.project}.iam.gserviceaccount.com"
}
