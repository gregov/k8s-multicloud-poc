variable "project" {
  type = string
  description = "Google Cloud project name"
  default = "k8s-multicloud-poc"
}

variable "gke_cluster_name" {
  type = string
  description = "Cluster name"
  default = "k8s-multicloud-poc-gcp"
}

variable "gke_region" {
  type = string
  description = "Default Google Cloud region"
  default = "australia-southeast1"
}

provider "google" {
  credentials = file("../secrets/account.json")
  project     = var.project
  region      = var.gke_region
}

variable "general_purpose_machine_type" {
  type = string
  description = "Machine type to use for the general-purpose node pool. See https://cloud.google.com/compute/docs/machine-types"
  default = "n1-standard-1"
}

variable "general_purpose_min_node_count" {
  type = string
  description = "The minimum number of nodes PER ZONE in the general-purpose node pool"
  default = 1
}

variable "general_purpose_max_node_count" {
  type = string
  description = "The maximum number of nodes PER ZONE in the general-purpose node pool"
  default = 3
}
